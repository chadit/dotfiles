


display_location()
{
    city=$(curl -s https://ipinfo.io/city 2> /dev/null)
    region=$(curl -s https://ipinfo.io/region 2> /dev/null)
    echo " $city, $region"
}
fetch_weather_information()
{
    display_weather=$1
    # it gets the weather condition textual name (%C), and the temperature (%t)
    curl -sL wttr.in/$fixedlocation\?format="%C+%t$display_weather"
}

#get weather display
display_weather()
{
    if $fahrenheit; then
        display_weather='&u' # for USA system
    else
        display_weather='&m' # for metric system
    fi
    weather_information=$(fetch_weather_information $display_weather)

    weather_condition=$(echo $weather_information | rev | cut -d ' ' -f2- | rev) # Sunny, Snow, etc
    temperature=$(echo $weather_information | rev | cut -d ' ' -f 1 | rev) # +31°C, -3°F, etc
    unicode=$(forecast_unicode $weather_condition)

    echo "$unicode${temperature/+/}" # remove the plus sign to the temperature
}

forecast_unicode()
{
    weather_condition=$(echo $weather_condition | awk '{print tolower($0)}')

    if [[ $weather_condition =~ 'snow' ]]; then
        echo '❄ '
    elif [[ (($weather_condition =~ 'rain') || ($weather_condition =~ 'shower')) ]]; then
        echo '☂ '
    elif [[ (($weather_condition =~ 'overcast') || ($weather_condition =~ 'cloud')) ]]; then
        echo '☁ '
    elif [[ $weather_condition = 'NA' ]]; then
        echo ''
    else
        echo '☀ '
    fi
}
