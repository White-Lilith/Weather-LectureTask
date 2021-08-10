public with sharing class WeatherCallout {
    
    

    public static List<List<Weather>> GetWeather() {
        List<List<Weather>> dailyWeather;

        Double latitude = 53.89;
        Double longitude=27.56; 

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        
        request.setEndpoint('https://www.7timer.info/bin/api.pl?lon='
                            + longitude +'&lat='
                            + latitude +'&product=astro&output=json');
        HttpResponse response = http.send(request);
        while(response.getStatusCode() == 302){
            request.setEndpoint(response.getHeader('Location'));
            response = http.send(request);
        }
        if(response.getStatusCode() == 200){
            WeatherService weatherService = (WeatherService) JSON.deserialize(response.getBody(), WeatherService.class);
            dailyWeather = MakeUpDailyWeather(weatherService);

        }
        return dailyWeather; 
    }
    static List<List<Weather>> MakeUpDailyWeather(WeatherService weatherService){
        List<List<Weather>> dailyWeather = new List<List<Weather>>();
        Integer day = -1;
        for (Weather w : weatherService.dataseries) {
            if(day < w.timePoint/24){
                day = w.timePoint/24;
                dailyWeather.add(new List<Weather>());
            }
            Weather weather = new Weather();
            weather.timePoint = w.timePoint - 24*day;
            weather.temp2m = w.temp2m;
            dailyWeather[day].add(weather);
        }
        return dailyWeather;
    }
}
