
# Pokemon API

**Pokemon API** is a toy project that exposes a REST API for a collection of pokemon data ([from here](https://gist.github.com/armgilles/194bcff35001e7eb53a2a8b441e8b2c6)).



## INSTALLATION

```
git clone https://github.com/phddb/pokemon_api
cd pokemon_api
bundle install
rake db:create db:migrate db:seed
```


## USAGE 

`bundle exec rake test` runs a suite of unit and integration tests

`bundle exec rails server` launches a development server



## API endpoints

<details>
  <summary><code>GET</code> <code><b>/pokemons</b></code> <code>(paginated index)</code></summary>

##### Parameters

> | name              |  type     | in                   | data type      | description                           |
> |-------------------|-----------|----------------------|----------------|---------------------------------------|
> | `per_page`          |  optional | query string or body | int            | Maximum number of pokemons to return (defaults to 25) |
> | `page`           |  optional | query string or body | int            | Which page of results to return (defaults to 1)  |


##### Responses

> | http code     | description              | response body                                      | example |
> |---------------|--------------------------|----------------------------------------------------|-----------------------------|
> | `200`         | `OK`                     | Array of json-encoded pokemons plus pagination metadata  |  `{"meta":{"current_page":1,"total_pages":32},"data":[{"Name":"Bulbasaur","Types":["Grass","Poison"],"Total":318,...`  |
                       

##### Example cURL

> ```javascript
>  curl -X GET 'localhost:3000/pokemons?per_page=25&page=1' 
> ```

</details>



<details>
  <summary><code>POST</code> <code><b>/pokemons</b></code> <code>(create)</code></summary>

##### Parameters

> | name              |  type     | in                   | data type      | description                           |
> |-------------------|-----------|----------------------|----------------|---------------------------------------|
> | `name`            |  required | body                 | string         | Name |
> | `hp`              |  required | body                 | int (1-255)    | HP  |
> | `attack`          |  required | body                 | int (1-255)    | Attack  |
> | `defense`         |  required | body                 | int (1-255)    | Defense  |
> | `sp_atk`          |  required | body                 | int (1-255)    | Sp. Atk  |
> | `sp_def`          |  required | body                 | int (1-255)    | Sp. Def |
> | `speed`           |  required | body                 | int (1-255)    | Speed  |
> | `generation`      |  required | body                 | int            | Generation  |
> | `legendary`       |  required | body                 | boolean        | Legendary  |
> | `types`           |  required | body                 | array of 1-2 unique strings | Types associated with this Pokemon. Must be valid pokemon types.(*)  |
 (*) Valid types: Grass, Poison, Fire, Flying, Dragon, Water, Bug, Normal, Electric, Ground, Fairy, Fighting, Psychic, Rock, Steel, Ice, Ghost, Dark.


##### Responses


> | http code     | description              | response body                                      | example |
> |---------------|--------------------------|----------------------------------------------------|-----------------------------|
> | `200`         | `OK`                     | `Newly created pokemon encoded as JSON`            | `{"Name":"Bulbasaur2","Types":["Grass","Poison"],"Total":318,...` |
> | `422`         | `Unprocessable Entity`          | `Description of issue` |  `{"name":["has already been taken"]}` |     



##### Example cURL

> ```javascript
> curl -X POST 'localhost:3000/pokemons.json' -H 'Content-Type: application/json' -d '{"name": "Bulbasaur2", "hp": 45, "attack": 49, "defense": 49, "sp_atk": 65, "sp_def": 65, "speed": 45, "generation": 1, "legendary": true, "types": ["Grass", "Poison"]}'
> ```

</details>




<details>
  <summary><code>GET</code> <code><b>/pokemon/{pokemonId}</b></code> <code>(retrieve)</code></summary>

##### Parameters

> | name              |  type     | in                   | data type      | description                           |
> |-------------------|-----------|----------------------|----------------|---------------------------------------|
> | `pokemonId`              |  required | path                 | int            | Unique identifier for a Pokemon  |


##### Responses

> | http code     | description              | response body                                      | example |
> |---------------|--------------------------|----------------------------------------------------|-----------------------------|
> | `200`         | `OK`                     | `Pokemon encoded as JSON`            | `{"Name":"Bulbasaur2","Types":["Grass","Poison"],"Total":318,...` |
> | `404`         | `Not Found`            |  |  |     



##### Example cURL

> ```javascript
>   curl -X GET 'localhost:3000/pokemons/1' 
> ```

</details>





<details>
  <summary><code>PATCH</code> <code><b>/pokemon/{pokemonId}</b></code> <code>(update)</code></summary>

##### Parameters

> | name              |  type     | in                   | data type      | description                           |
> |-------------------|-----------|----------------------|----------------|---------------------------------------|
> | `pokemonId`              |  required | path                 | int             | Unique identifier for a Pokemon  |
> | `name`            |  optional | body                 | string         | Name |
> | `hp`              |  optional | body                 | int (1-255)    | HP  |
> | `attack`          |  optional | body                 | int (1-255)    | Attack  |
> | `defense`         |  optional | body                 | int (1-255)    | Defense  |
> | `sp_atk`          |  optional | body                 | int (1-255)    | Sp. Atk  |
> | `sp_def`          |  optional | body                 | int (1-255)    | Sp. Def |
> | `speed`           |  optional | body                 | int (1-255)    | Speed  |
> | `generation`      |  optional | body                 | int            | Generation  |
> | `legendary`       |  optional | body                 | boolean        | Legendary  |
> | `types`           |  optional | body                 | array of 0-2 unique strings | Types associated with this Pokemon. Must be valid pokemon types.(*)  |
 (*) Valid types: Grass, Poison, Fire, Flying, Dragon, Water, Bug, Normal, Electric, Ground, Fairy, Fighting, Psychic, Rock, Steel, Ice, Ghost, Dark.


##### Responses

> | http code     | description              | response body                                      | example |
> |---------------|--------------------------|----------------------------------------------------|-----------------------------|
> | `200`         | `OK`                     | `Updated pokemon encoded as JSON`            | `{"Name":"Bulbasaur2","Types":["Grass","Poison"],"Total":318,...` |
> | `422`         | `Unprocessable Entity`   | `Description of issue` |  `{"hp":["must be less than or equal to 255"]}` |     
> | `404`         | `Not Found`            |  |  |     


                                                      
##### Example cURL

> ```javascript
>   curl -X PATCH 'localhost:3000/pokemons/1' -d 'hp=45'
> ```

</details>




<details>
  <summary><code>DELETE</code> <code><b>/pokemon/{pokemonId}</b></code> <code>(delete)</code></summary>

##### Parameters

> | name              |  type     | in                   | data type      | description                           |
> |-------------------|-----------|----------------------|----------------|---------------------------------------|
> | `pokemonId`       |  required | path                 | int            | Unique identifier for a Pokemon  |


##### Responses

> | http code     | description              | response body                                      | example |
> |---------------|--------------------------|----------------------------------------------------|-----------------------------|
> | `204`         | `No Content`             |  |  |
> | `404`         | `Not Found`              |  |  |     


##### Example cURL

> ```javascript
> curl -X DELETE 'localhost:3000/pokemons/1' 
> ```

</details>


