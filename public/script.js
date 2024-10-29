const city = document.getElementById('input-city');
const buttonSearch = document.getElementById('button-search');
const containerWeather = document.getElementById('container-weather');

containerWeather.style.display = "none";

buttonSearch.addEventListener('click', () => {
    const cityName = city.value;
    const openWeatherK = 'd82624570c71e083ef8ee799177019d0'; // Chave é ativada/desativada no portal do OpenWeather
    const url = `https://api.openweathermap.org/data/2.5/weather?q=${cityName}&appid=${openWeatherK}&units=metric&lang=pt_br`;

    fetch(url)
        .then(response => response.json())
        .then(data => {
            console.log('Weather:', data);

            const weatherHtml = `
                <h2><span id="city">${data.name}</span>, <span id="country">${data.sys.country}</span></h2>
                <p>Temperatura: ${data.main.temp} °C</p>
                <p>Sensação: ${data.main.feels_like} °C</p>
                <p>Vento: ${data.wind.speed} km/h</p>
                <p>Umidade: ${data.main.humidity}%</p>
                <p>Condição: ${data.weather[0].description.charAt(0).toUpperCase() + data.weather[0].description.slice(1)}</p>
                <img src="http://openweathermap.org/img/wn/${data.weather[0].icon}@2x.png" />
            `;
            containerWeather.style.display = "flex";
            containerWeather.innerHTML = weatherHtml;
        })
        .catch((error) => {
            console.error('Erro ao buscar a informação:', error);
            containerWeather.style.display = "flex";
            containerWeather.innerHTML = 'Erro ao carregar o clima :(';
        });
});
