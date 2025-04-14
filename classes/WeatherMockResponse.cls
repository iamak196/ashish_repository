global class WeatherMockResponse implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a mock HTTP response
        HTTPResponse response = new HTTPResponse();
        response.setStatusCode(200);
        String mockJson = '{"location":{"name":"Milton Keynes","region":"Buckinghamshire","country":"United Kingdom","lat":52.0293,"lon":-0.7552,"tz_id":"Europe/London","localtime_epoch":1744646799,"localtime":"2025-04-14 17:06"},"current":{"last_updated_epoch":1744646400,"last_updated":"2025-04-14 17:00","temp_c":14.0,"temp_f":57.2,"is_day":1,"condition":{"text":"Partly cloudy","icon":"//cdn.weatherapi.com/weather/64x64/day/116.png","code":1003},"wind_mph":11.2,"wind_kph":18.0,"wind_degree":170,"wind_dir":"S","pressure_mb":1002.0,"pressure_in":29.59,"precip_mm":0.0,"precip_in":0.0,"humidity":51,"cloud":25,"feelslike_c":12.6,"feelslike_f":54.6,"windchill_c":9.7,"windchill_f":49.4,"heatindex_c":11.7,"heatindex_f":53.0,"dewpoint_c":6.7,"dewpoint_f":44.0,"vis_km":10.0,"vis_miles":6.0,"uv":0.6,"gust_mph":15.2,"gust_kph":24.4}}';
        response.setBody(mockJson);

        return response;
    }
}