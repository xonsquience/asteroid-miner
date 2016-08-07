import IWD # Ian Webster's dictionaries
import csv
import math

# load database of unique asteroids
# fulldb actually contains a lot of non-asteroid objects :/
data = open('latest_fulldb.csv', 'rb')
asteroids = list(csv.reader(data))
data.close()

# load database of close approaches until 2050
ca = open('til2050.csv', 'rb')
til2050 = list(csv.reader(ca))
ca.close()

# make table of usable asteroids with desired data. give it headers.
A = []
A.append(['full_name', 'pdes', 'name', 'aluminum kg', 'aluminum usd',
          'iron silicate kg', 'iron silicate usd', 'magnesium silicate kg',
          'magnesium silicate usd', 'platinum kg', 'platinum usd',
          'stainless steel kg', 'stainless steel usd', 'cobalt kg',
          'cobalt usd', 'nickel-iron kg', 'nickel-iron usd', 'nickel kg',
          'nickel usd', 'iron kg', 'iron usd', 'oxygen kg', 'oxygen usd',
          'ammonia kg', 'ammonia usd', 'nitrogen kg', 'nitrogen usd',
          'hydrogen kg', 'hyrogen usd', 'water kg', 'water usd',
          'total_value', 'close_approaches'])

# materials
materials = ['aluminum', 'iron silicate', 'magnesium silicate', 'platinum',
             'stainless steel', 'cobalt', 'nickel-iron', 'nickel', 'iron',
             'oxygen', 'ammonia', 'nitrogen', 'hydrogen', 'water']

for i in range(1,len(asteroids)):
    # check if asteroid has diameter (or can be estimated with H and albedo)
    # check if asteroid has spec_B or spec_T data
    a = asteroids[i]
    if (a[15]!='' or a[8]!='') and (a[23]!='' or a[24] in IWD.THOLEN_MAPPINGS):
        H = float(a[8])
        
        # default albedo value
        albedo = .15
        
        # name
        l = [a[2], a[3], a[4]]
        
        # type
        t = ''
        if a[23]!='':
            t = a[23]
            if a[23][-1] == ':':
                t = a[23][:-1]
        else:
            t = IWD.THOLEN_MAPPINGS[a[24]]

        # asteroid dimensions
        r = 0
        if a[15]!='':
            r = float(a[15])/2
        else:
            if a[17] != '':
                albedo = float(a[17])
            # Ian Webster's formula for estimating radius from H and albedo
            r = 664.5 / math.sqrt(albedo) * (10 ** (-0.2 * H))

        # km^3
        V = (4.0/3) * math.pi * (r ** 3)
        # kg/km^3
        d = 2 * 1e12
        if t in IWD.TYPE_DENSITY_MAP:
            d = IWD.TYPE_DENSITY_MAP[t] * 1e12
        # kg
        Amass = d*V
             
        # material
        if t!='':
            for M in materials:
                if M in IWD.SPECTRA_INDEX[t]:
                    l.append(IWD.SPECTRA_INDEX[t][M]*.01*Amass)
                    l.append(IWD.MATERIALS_INDEX[M]['$_per_kg'] * IWD.SPECTRA_INDEX[t][M]*.01*Amass)
                else:
                    l.extend([0,0])
                    
        # total value
        v = 0
        i = 4
        while i <= len(l):
            v += float(l[i])
            i += 2
        if v > 1:
            l.append(v)
        else:
            l.append(0)
            
        # close approaches
        ca = ''
        for approach in til2050:
            name = approach[0].replace('\xc2\xa0', ' ')
            date = approach[1][:11]
            
            # check if pdes is first word of name. check '3103 Eger'
            if l[1] == name[:name.find(' ')]:
                ca += ' '+date
                
            # check if name is second (& last) word
            elif l[2] != '' and l[2] == name[len(name)-len(l[2]):]:
                ca += ' '+date
            
            # check parenthetical name
            elif '(' in l[0]:
                if l[0][l[0].find('('):] == name[len(name)-len(l[0][l[0].find('('):]):]:
                    ca += ' '+date
            
        ca.lstrip(' ')
        l.append(ca)
        
        if t!='' and ca!='':
            A.append(l)
        
with open('A_A.csv', 'wb') as f:
    csv.writer(f).writerows(A)
