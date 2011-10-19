# -*- coding: utf-8 -*-

require 'open-uri'#import urllib
require 'json'#import simplejson
require 'active_support/core_ext'#zamiana na zapytania
require 'net/http'


ELEVATION_BASE_URL = 'http://maps.googleapis.com/maps/api/elevation/json'
CHART_BASE_URL = 'http://chart.apis.google.com/chart'

#def getChart(chartData, chartDataScaling="-500,5000", chartType="lc",chartLabel="Elevation in Meters",chartSize="500x160",chartColor="orange", **chart_args):
#    chart_args.update({
#      'cht': chartType,
#      'chs': chartSize,
#      'chl': chartLabel,
#      'chco': chartColor,
#      'chds': chartDataScaling,
#      'chxt': 'x,y',
#      'chxr': '1,-500,5000'
#    })
#
#    dataString = 't:' + ','.join(str(x) for x in chartData)
#    chart_args['chd'] = dataString.strip(',')
#
#    chartUrl = CHART_BASE_URL + '?' + urllib.urlencode(chart_args)
#
#    print chartUrl

def getChart(chartData, chartDataScaling="-500,5000", chartType="lc", chartLabel="Z UG do Slupska", chartSize="500x200", chartColor="red", chart_args={})
#def getChart(chartData, chartDataScaling="-500,5000", chartType="lc",chartLabel="Elevation in Meters",chartSize="500x160",chartColor="orange", **chart_args):
    chart_args.merge!({#    chart_args.update({
        cht: chartType,#'	cht': chartType,
        chs: chartSize,#      'chs': chartSize,,
        chl: chartLabel,#      'chl': chartLabel,
        chco: chartColor,#      'chco': chartColor,
        chds: chartDataScaling,#      'chds': chartDataScaling,
        chxt: 'x,y',#      'chxt': 'x,y',
        chxr: '1,-500,5000'#      'chxr': '1,-500,5000'
    })

    dataString = 't:' + chartData.join(',')
    chart_args['chd'] = dataString
   
    chartUrl = CHART_BASE_URL + '?' + chart_args.to_query

    puts chartUrl
end

#def getElevation(path="36.578581,-118.291994|36.23998,-116.83171",samples="100",sensor="false", **elvtn_args):
#      elvtn_args.update({
#        'path': path,
#        'samples': samples,
#        'sensor': sensor
#      })
#
#      url = ELEVATION_BASE_URL + '?' + urllib.urlencode(elvtn_args)
#      response = simplejson.load(urllib.urlopen(url))
#
#      # Create a dictionary for each results[] object
#      elevationArray = []
#
#      for resultset in response['results']:
#        elevationArray.append(resultset['elevation'])
#
# Create the chart passing the array of elevation data
#      getChart(chartData=elevationArray)

def getElevation(path="36.578581,-118.291994|36.23998,-116.83171", chartLabel="Elevation in Meters", samples="100",sensor="false", elvtn_args={})
#def getElevation(path="36.578581,-118.291994|36.23998,-116.83171",samples="100",sensor="false", **elvtn_args):
    elvtn_args.merge!({#      elvtn_args.update({
        path: path,#        'path': path,
        chartLabel: chartLabel,
        samples: samples,#        'samples': samples,
        sensor: sensor#        'sensor': sensor
    })
   
    url = ELEVATION_BASE_URL + '?' + elvtn_args.to_query#      url = ELEVATION_BASE_URL + '?' + urllib.urlencode(elvtn_args)
    #parsujemy i get_response
    resp = Net::HTTP.get_response(URI.parse(url))#      response = simplejson.load(urllib.urlopen(url))
    response = JSON.parse(resp.body)#zamiana json`a

    # Create a dictionary for each results[] object
    elevationArray = []
    for result in response['results']
      elevationArray << result["elevation"].round(0) # zaokraglamy (za duzo miejsc po przecinku)
    end
    
    # Create the chart passing the array of elevation data
    getChart(elevationArray)
end

if __FILE__ == $PROGRAM_NAME #if __name__ == '__main__':

    puts 'Wspolrzedne punktu startowego ( domyslnie UG )'
    startStr = gets.gsub(' ','').chomp
    if startStr.empty?
      startStr = "18.5634398,54.3973498"
      chartLabel1="Z UG "
    end
    puts "Wspolrzedne punktu koncowego ( domyslnie Slupsk )"
    endStr = gets.gsub(' ','').chomp
    if endStr.empty?
      endStr = "16.9959998,54.4589880"
      chartLabel2="do Slupska"
    end
    pathStr = startStr + "|" + endStr
    chartLabel=chartLabel1+chartLabel2
    getElevation(pathStr, chartLabel)

end
