# -*- coding: utf-8 -*-
"""
Created on Fri May 13 13:25:24 2016

@author: mcooper
"""

from reportlab.lib.pagesizes import letter
from reportlab.lib.units import inch
from reportlab.pdfgen import canvas
from reportlab.lib.colors import white, black
import string
import os
import random
import code128
import sys
import shutil
import time

#To Do: 
#Document each function & its arguments
#Error Handling
#maybe add a light color background to draw rect, to keep individual barcodes separate

def generateBarcodes(country, number, protocol, dryrun=False):
    ctry = country[0].upper() 
    
    if not dryrun:
        os.mkdir('TEMP')
        usedcodes = [line.rstrip() for line in open('used_codes.txt')]
    
    combos = []
    for a1 in list(string.ascii_lowercase):
        for a2 in list(string.ascii_lowercase):
            for a3 in list(string.ascii_lowercase):
                combos.append(a1+a2+a3)
    
    if not dryrun:    
        cleancombos = [x for x in combos if x not in usedcodes]
    else:
        cleancombos = [x for x in combos]
        
    selectcombos = random.sample(cleancombos, int(number))
                
    barcodes = []
    
    if protocol=='Eplot':
        for i in selectcombos:
            for d in ['1', '2', '3', '4']:
                barcode = ctry + '-' + i + '-' + d
                barcodes.append(barcode)
    
    elif protocol=='FFS':
        for i in selectcombos:
            barcode = ctry + '-' + i
            barcodes.append(barcode)
    
    if not dryrun:
        f = open('used_codes.txt', 'a')
        for i in selectcombos:
            f.write(i + '\n')
        f.close()
        
        for b in barcodes:
            code128.image(b).save('TEMP/' + b + '.png')
        
    return barcodes

coords = [[[8.5, 0.5], [8.5, 2.0], [9.5, 0.5], [9.5, 2.0]],
[[8.5, 3.5], [8.5, 5.0], [9.5, 3.5], [9.5, 5.0]],
[[6.5, 0.5], [6.5, 2.0], [7.5, 0.5], [7.5, 2.0]],
[[6.5, 3.5], [6.5, 5.0], [7.5, 3.5], [7.5, 5.0]],
[[4.5, 0.5], [4.5, 2.0], [5.5, 0.5], [5.5, 2.0]],
[[4.5, 3.5], [4.5, 5.0], [5.5, 3.5], [5.5, 5.0]],
[[2.5, 0.5], [2.5, 2.0], [3.5, 0.5], [3.5, 2.0]],
[[2.5, 3.5], [2.5, 5.0], [3.5, 3.5], [3.5, 5.0]],
[[0.5, 0.5], [0.5, 2.0], [1.5, 0.5], [1.5, 2.0]],
[[0.5, 3.5], [0.5, 5.0], [1.5, 3.5], [1.5, 5.0]],
[[9.5, 6.5], [8.5, 6.5], [7.5, 6.5], [6.5, 6.5]],
[[5.5, 6.5], [4.5, 6.5], [3.5, 6.5], [2.5, 6.5]]]

def drawRects(c, linewidth):
    c.setLineWidth(linewidth)
    c.rect(0.5*inch, 0.5*inch, width = 3*inch, height = 2*inch)
    c.rect(0.5*inch, 2.5*inch, width = 3*inch, height = 2*inch)
    c.rect(0.5*inch, 4.5*inch, width = 3*inch, height = 2*inch)
    c.rect(0.5*inch, 6.5*inch, width = 3*inch, height = 2*inch)
    c.rect(0.5*inch, 8.5*inch, width = 3*inch, height = 2*inch)
    c.rect(3.5*inch, 0.5*inch, width = 3*inch, height = 2*inch)
    c.rect(3.5*inch, 2.5*inch, width = 3*inch, height = 2*inch)
    c.rect(3.5*inch, 4.5*inch, width = 3*inch, height = 2*inch)
    c.rect(3.5*inch, 6.5*inch, width = 3*inch, height = 2*inch)
    c.rect(3.5*inch, 8.5*inch, width = 3*inch, height = 2*inch)
    c.rect(0.5*inch, 0.5*inch, width = 3*inch, height = 2*inch)
    c.rect(0.5*inch, 0.5*inch, width = 3*inch, height = 2*inch)
    c.rect(6.5*inch, 6.5*inch, width = 1.5*inch, height = 4*inch)
    c.rect(6.5*inch, 2.5*inch, width = 1.5*inch, height = 4*inch)
        
def newPage(c, country, pagenumber, first):
    if not first:
        c.showPage()
    c.setFont("Helvetica", 25)
    c.drawString(x=0.5*inch, y=10.6*inch, text='Vital Signs Soil Tracking Barcodes for ' + country)
    c.setFont("Courier", 10)
    c.drawCentredString(x=0.25*inch, y=10.6*inch, text=str(pagenumber))
    c.drawCentredString(x=0.25*inch, y=0.1*inch, text=str(pagenumber))
    c.drawCentredString(x=8.25*inch, y=10.6*inch, text=str(pagenumber))
    c.drawCentredString(x=8.25*inch, y=0.1*inch, text=str(pagenumber))
    c.setFont("Helvetica", 15)
    c.drawCentredString(x=4.25*inch, y=.1*inch, text='Thanks for all of the hard work, everyone!')
    pagenumber += 1
    return pagenumber
    
def createLabel(b, country):
    countrydict = {'Uganda': 'UGA', 'Rwanda': 'RWA', 'Tanzania': 'TZA', 'Kenya': 'KEN', 'Ghana': 'GHA'}
    label = countrydict[country] + ' '
    if len(b)==5:
        label = label + 'FFS 0-20cm'
    if len(b)==7:
        label = label + 'Eplot '
        if b[6]=='1':
            label = label + '0-20cm'
        elif b[6]=='2':
            label = label + '20-50cm'
        elif b[6]=='3':
            label = label + '50-80cm'
        elif b[6]=='4':
            label = label + '80-100cm'
    return label
    
def printCountryBarcodes(country, barcodes):
    c = canvas.Canvas(country + '_' + time.strftime("%d-%m-%Y") + ".pdf", pagesize=letter)
    pagenumber = 1
    pagenumber = newPage(c, country, pagenumber, first=True)
    
    for b in barcodes:
        pageindex = barcodes.index(b)%12
        coord = coords[pageindex]
        for h,w in coord:
            c.drawImage('TEMP/' + b + '.png', x=w*inch, y=h*inch, width=1.5*inch, height=1*inch)
            c.setFillColor(white)
            c.rect(x=w*inch, y=(h+.75)*inch, width=1.5*inch, height=0.25*inch, stroke=0, fill=1)
            c.rect(x=w*inch, y=h*inch, width=1.5*inch, height=0.15*inch, stroke=0, fill=1)
            c.setFillColor(black)
            c.setFont("Courier", 7)
            label = createLabel(b, country)
            c.drawString(x=(w+.14)*inch, y=(h+.78)*inch, text=label)
            c.drawCentredString(x=(w+.75)*inch, y=(h+.07)*inch, text=b)
        if pageindex == 11: 
            drawRects(c, 2)
        if pageindex == 11 and b != barcodes[-1]:
            pagenumber = newPage(c, country, pagenumber, first=False)

    drawRects(c, 2)
    c.save()
    shutil.rmtree('TEMP')

def main(country, number, protocol):
    barcodes = generateBarcodes(country, number, protocol)
    printCountryBarcodes(country, barcodes)

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2], sys.argv[3])
    
