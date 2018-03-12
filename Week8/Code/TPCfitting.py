#!/usr/bin/env python

"""
Fitting models to TPC data using lmfit. 
Four models will be fitted, the Schoolfield model, two partial Schoolfield models (one for higher and one for lower temperatures), and a cubic model.
"""

__author__ = "Louie Adams (la2417@ic.ac.uk)"
__version__ = "0.0.1"
__date__ = "Feb 2018"


import pandas as pd
import numpy as np
import scipy.constants as sc
import lmfit as lm
from lmfit import Parameters, minimize
import warnings



# read in data
data = pd.read_csv("../Data/TPCdata.csv")

# save Boltzmann constant
k = sc.physical_constants["Boltzmann constant in eV/K"][0]


# define function to extract starting parameters from mdataframe and save to Parameters() dictionary for use with lm.minimize
def getParamsFull(data):
    params = Parameters()
    params.add("B0", value=data["B0"].iloc[0], min = 0)
    params.add("Th", value=data["Th"].iloc[0], min = 1)
    params.add("Tl", value=data["Tl"].iloc[0], min = 1)
    params.add("E", value=data["E"].iloc[0], min = 0)
    params.add("Eh", value=(2 * data["E"].iloc[0]), min = data["E"].iloc[0])
    params.add("El", value=(0.5 * data["E"].iloc[0]), min = 0, max = data["E"].iloc[0]) 

    return params


# define function to fit full Schoolfield model to data and calculate residuals
def resids(Params, Temperatures, TraitValues):
    # save parameters for cleaner equation below
    B0 = params["B0"]
    Th = params["Th"]
    Tl = params["Tl"]
    E = params["E"]
    Eh = params["Eh"]
    El = params["El"]
    
    # fit logged Schoolfield model
    logB = np.log(B0) - ( (E/k) * ((1/Temperatures) - (1/283.15)) ) - np.log( 1 + np.exp( (El/k) * ( (1/Tl) - (1/Temperatures) ) ) + np.exp( (Eh / k) * ( (1/Th) - (1/Temperatures) ) ) )
    
    # calculate residuals
    residuals = np.log(TraitValues) - logB
    return residuals




# loop through all data sets in dataframe using lm.minmize to find parameter estimates that will minimize residuals from logged Schoolfield model
for i in np.unique(data["MyID"]): 
    #subset data frame
    subset = data.loc[data["MyID"]==i]
    temperatures = subset["ConTempKelvin"]
    traitValues = subset["OriginalTraitValue"]
    logTraitValues = np.log(traitValues)
    # extract starting parameters
    params = getParamsFull(data = subset)
        
    # use try to deal with common errors from lm.minimize
    try: 
        # use lm.minimize to minimize residuals and get parameter estimates
        fit = lm.minimize(resids, params, args=(temperatures, traitValues))
        
        # add parameters found using lm.minimize to new columns in dataframe
        data.loc[data["MyID"] == i, "B0FullMod"] = fit.params["B0"].value
        data.loc[data["MyID"] == i, "ThFullMod"] = fit.params["Th"].value
        data.loc[data["MyID"] == i, "TlFullMod"] = fit.params["Tl"].value
        data.loc[data["MyID"] == i, "EFullMod"] = fit.params["E"].value
        data.loc[data["MyID"] == i, "EhFullMod"] = fit.params["Eh"].value
        data.loc[data["MyID"] == i, "ElFullMod"] = fit.params["El"].value 

        # calculate coefficient of determination
        mean = np.mean(logTraitValues)
        tSS = np.var(logTraitValues) * (len(logTraitValues)-1)
        # totalSumSquares = np.sum(np.square(logTraitValues - mean))
        rSS = np.sum(np.square(fit.residual))
        Rsqu = 1-(rSS/tSS)

        # add R squared column to dataframe  
        data.loc[data["MyID"] == i, "RsquaredFullMod"] = Rsqu

        # calculate AIC and BIC
        # rSSunlogged = 
        # tSSunlogged = 
        # noP is number of parameters used in model
        noP = 6 
        AIC = len(traitValues) * np.log( (2*np.pi) / len(traitValues) ) + len(traitValues) + 2 + (len(traitValues) * rSS) + (2 * noP)
        BIC = len(traitValues) + (len(traitValues) * np.log(2 * np.pi)) + (len(traitValues) * np.log(rSS / len(traitValues))) + (np.log(len(traitValues)) * (noP+1))

        # Add AIC and BIC to new column in dataframe
        data.loc[data["MyID"] == i, "AICFullMod"] = AIC
        data.loc[data["MyID"] == i, "BICFullMod"] = BIC
    
    # if a TypeError occurs, fill columns with NA's 
    except(TypeError):

        data.loc[data["MyID"] == i, "AICFullMod"] = "NA"
        data.loc[data["MyID"] == i, "BICFullMod"] = "NA"
        data.loc[data["MyID"] == i, "B0FullMod"] = "NA"
        data.loc[data["MyID"] == i, "ThFullMod"] = "NA"
        data.loc[data["MyID"] == i, "TlFullMod"] = "NA"
        data.loc[data["MyID"] == i, "EFullMod"] = "NA"
        data.loc[data["MyID"] == i, "EhFullMod"] = "NA"
        data.loc[data["MyID"] == i, "ElFullMod"] = "NA"    
        data.loc[data["MyID"] == i, "RsquaredFullMod"] = "NA"

# Common error in lm.minimize
# TypeError: Improper input: N=6 must not exceed M=5




#### simplified Schoolfield models ####


#### for higher temperature measurements ####

def getParamsHigh(data):
    params = Parameters()
    params.add("B0", value=data["B0"].iloc[0], min = 0)
    params.add("Th", value=data["Th"].iloc[0], min = 1)
    params.add("E", value=data["E"].iloc[0], min = 0)
    params.add("Eh", value=(2 * data["E"].iloc[0]), min = data["E"].iloc[0])
    
    return params


def residsHigh(Params, Temperatures, TraitValues):
    logB = np.log(params["B0"]) - ( (-params["E"]/k) * ((1/Temperatures) - (1/283.15)) ) - np.log( 1 + np.exp( (params["Eh"] / k) * ( (1/params["Th"]) - (1/Temperatures) ) ) )


    residualsHigh = TraitValues - logB
    return residualsHigh



for i in np.unique(data["MyID"]): 
    subset = data.loc[data["MyID"]==i]
    temperatures = subset["ConTempKelvin"]
    traitValues = subset["OriginalTraitValue"]
    logTraitValues = np.log(traitValues)
    params = getParamsHigh(data = subset)
        
    try: 

        fit = lm.minimize(residsHigh, params, args=(temperatures, logTraitValues))

        data.loc[data["MyID"] == i, "B0outHighMod"] = fit.params["B0"].value
        data.loc[data["MyID"] == i, "ThOutHighMod"] = fit.params["Th"].value
        data.loc[data["MyID"] == i, "EOutHighMod"] = fit.params["E"].value
        data.loc[data["MyID"] == i, "EhOutHighMod"] = fit.params["Eh"].value
        
        mean = np.mean(logTraitValues)
        tSS = np.var(logTraitValues) * (len(logTraitValues)-1)
        rSS = np.sum(np.square(fit.residual))
        Rsqu = 1-(rSS/tSS)

        data.loc[data["MyID"] == i, "RsquaredHighMod"] = Rsqu

        noP = 4 
        AIC = len(traitValues) * np.log( (2*np.pi) / len(traitValues) ) + len(traitValues) + 2 + (len(traitValues) * rSS) + (2 * noP)
        BIC = len(traitValues) + (len(traitValues) * np.log(2 * np.pi)) + (len(traitValues) * np.log(rSS / len(traitValues))) + (np.log(len(traitValues)) * (noP+1))

        # Add AIC and BIC to new column in dataframe
        data.loc[data["MyID"] == i, "AIChighMod"] = AIC
        data.loc[data["MyID"] == i, "BIChighMod"] = BIC

    except(TypeError):

        data.loc[data["MyID"] == i, "B0outHighMod"] = "NA"
        data.loc[data["MyID"] == i, "ThOutHighMod"] = "NA"
        data.loc[data["MyID"] == i, "EOutHighMod"] = "NA"
        data.loc[data["MyID"] == i, "EhOutHighMod"] = "NA"    
        data.loc[data["MyID"] == i, "RsquaredHighMod"] = "NA"




#### for lower temperature measurements ####

def getParamsLow(data):
    params = Parameters()
    params.add("B0", value=data["B0"].iloc[0], min = 0)
    params.add("Tl", value=data["Tl"].iloc[0], min = 1)
    params.add("E", value=data["E"].iloc[0], min = 0)
    params.add("El", value=(0.5 * data["E"].iloc[0]), min = 0, max = data["E"].iloc[0]) 

    return params



def residsLow(Params, Temperatures, TraitValues):
    logB = np.log(params["B0"]) - ( (-params["E"]/k) * ((1/Temperatures) - (1/283.15)) ) - np.log( 1 + np.exp( (params["El"]/k) * ( (1/params["Tl"]) - (1/Temperatures) ) ) )

    residualsLow = TraitValues - logB
    return residualsLow



for i in np.unique(data["MyID"]): 
    subset = data.loc[data["MyID"]==i]
    temperatures = subset["ConTempKelvin"]
    traitValues = subset["OriginalTraitValue"]
    logTraitValues = np.log(traitValues)
    params = getParamsLow(data = subset)
        
    try: 

        fit = lm.minimize(residsLow, params, args=(temperatures, logTraitValues))
        
        data.loc[data["MyID"] == i, "B0outLowMod"] = fit.params["B0"].value
        data.loc[data["MyID"] == i, "TlOutLowMod"] = fit.params["Tl"].value
        data.loc[data["MyID"] == i, "EOutLowMod"] = fit.params["E"].value
        data.loc[data["MyID"] == i, "ElOutLowMod"] = fit.params["El"].value    
        
        mean = np.mean(logTraitValues)
        tSS = np.var(logTraitValues) * (len(logTraitValues)-1)
        rSS = np.sum(np.square(fit.residual))
        Rsqu = 1-(rSS/tSS)

        data.loc[data["MyID"] == i, "RsquaredLowMod"] = Rsqu

        noP = 4 
        AIC = len(traitValues) * np.log( (2*np.pi) / len(traitValues) ) + len(traitValues) + 2 + (len(traitValues) * rSS) + (2 * noP)
        BIC = len(traitValues) + (len(traitValues) * np.log(2 * np.pi)) + (len(traitValues) * np.log(rSS / len(traitValues))) + (np.log(len(traitValues)) * (noP+1))

        # Add AIC and BIC to new column in dataframe
        data.loc[data["MyID"] == i, "AIClowMod"] = AIC
        data.loc[data["MyID"] == i, "BIClowMod"] = BIC

    except(TypeError):

        data.loc[data["MyID"] == i, "B0outLowMod"] = "NA"
        data.loc[data["MyID"] == i, "TlOutLowMod"] = "NA"
        data.loc[data["MyID"] == i, "EOutLowMod"] = "NA"
        data.loc[data["MyID"] == i, "ElOutLowMod"] = "NA"    
        data.loc[data["MyID"] == i, "RsquaredLowMod"] = "NA"




#### cubic model ####


# ignores warning messages (added at end of writing script, once all warnings are already known about) 
warnings.simplefilter('ignore', np.RankWarning)

for i in np.unique(data["MyID"]): 
    subset = data.loc[data["MyID"]==i]
    temperatures = np.array(subset.ConTempKelvin)
    traitValues = np.array(subset.OriginalTraitValue)
    
    # np.polyfit estimates parameters given observed data
    coefficients = np.polyfit(temperatures, traitValues, 3)
    # store these parameters in new columns in data frame
    data.loc[data["MyID"] == i, "cubicB0"] = coefficients [3]
    data.loc[data["MyID"] == i, "cubicB1"] = coefficients [2]
    data.loc[data["MyID"] == i, "cubicB2"] = coefficients [1]
    data.loc[data["MyID"] == i, "cubicB3"] = coefficients [0]

    # find cubic model fitted values and add to new column in dataframe
    cubicModel = coefficients [3] + coefficients [2]*temperatures + coefficients [1]*np.square(temperatures) + coefficients [0]*np.power(temperatures, 3)    
    data.loc[data["MyID"] == i, "cubicModelFittedValue"] = cubicModel

    # calculate coefficient of determinatation (Rsquared)
    mean = np.mean(traitValues)
    tSS = np.var(traitValues) * (len(traitValues)-1)
    residuals = traitValues - cubicModel
    rSS = np.sum(residuals)
    Rsqu = 1-(rSS/tSS)
    # store R squared in new column in data frame
    data.loc[data["MyID"] == i, "RsquaredCubicMod"] = Rsqu

    # calculate AIC and BIC
    noP = 4 
    AIC = len(traitValues) * np.log( (2*np.pi) / len(traitValues) ) + len(traitValues) + 2 + (len(traitValues) * rSS) + (2 * noP)
    # BIC = len(traitValues) + (len(traitValues) * np.log(2 * np.pi)) + (len(traitValues) * np.log(rSS / len(traitValues))) + (np.log(len(traitValues)) * (noP+1))

    # Add AIC and BIC to new column in dataframe
    data.loc[data["MyID"] == i, "AICcubicMod"] = AIC
    # data.loc[data["MyID"] == i, "BICcubicMod"] = BIC


# warning comes up when fitting cubic
# /usr/lib/python2.7/dist-packages/numpy/lib/polynomial.py:595: RankWarning: Polyfit may be poorly conditioned
#   warnings.warn(msg, RankWarning)

    
# write data frame out to csv
data.to_csv("../Data/fittedData.csv") 