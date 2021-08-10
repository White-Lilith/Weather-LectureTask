public with sharing class WeatherController {
    public List<List<Weather>> DailyWeather {get;set;}
    public Integer num {get;set;}
    public WeatherController(){
        DailyWeather = WeatherCallout.GetWeather();
    }
}
