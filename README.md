# ParcelManager API


## Sobre o projeto

ParcelManager é um projeto desenvolvido como resolução do desafio proposto pela empresa Granter e tem como finalidade a simulação de um gerenciador de encomendas onde é possível criar locatizações, encomendas e realizar transferências de uma localização para outra através da aplicação. O projeto foi desenvolvido utilizando a linguagem de programação Elixir e seu Framework Web mais popular Phoenix. Optei por brincar um pouco com os conceitos de DDD na aplicação para aprimoramento dos meus conhecimentos enquanto soluciono o desafio proposto.
Link do desafio: https://gitlab.com/granter-challenges/elixir-challenge.

### Configurações de ambiente

Para executar esse projeto você precisará instalar corretamente em sua máquina o Elixir, Phoenix Framework e o Docker com uma imagem do PostgreSQL configurada. Caso ainda não os tenha instalados, siga os seguintes passos disponibilizados pela documentação oficial das tecnologias:

  - [Instalando o Elixir](https://elixir-lang.org/install.html).
  - [Instalando o Phoenix](https://hexdocs.pm/phoenix/installation.html).
  - [Instalando o Docker](https://docs.docker.com/engine/install/).

Após instalar o docker é necessário configurar a imagem do postgres, fazendo o pull da imagem oficial:

```bash
# Baixa a imagem oficial do postgres para o docker
$ sudo docker pull postgres
```

Na sequência execute o comando a seguir para subir um container com a imagem postgres recém baixada:

```bash
# Sobe um container no docker com a imagem do postgres configurada para utilização
$ sudo docker run --name parcel_manager_db -p 5432:5432 -e POSTGRES_PASSWORD=postgres -e POSTGRES_USER=postgres -e POSTGRES_DB=parcel_manager_dev -d postgres
```


### Configurações do projeto

Com toda a configuração de ambiente pronta, podemos então configurar nosso projeto. Primeiro passo é necessário clonar o projeto, acessando o terminal no diretório de sua preferência e executar:

```bash
# Baixa o repositório parcel_manager do github
$ git clone https://gitlab.com/gideonf.dev/parcel_manager.git
```

Na sequência execute o comando 'mix deps.get' dentro do diretório do projeto para baixar as dependências:

```bash
# Acessa o projeto e baixa as dependencias necessárias
$ cd parcel_manager/
$ mix deps.get
```

Após isso devemos garantir que as configurações do banco de dados estão em conformidade com as configurações do PostgreSQL que está online através do container do docker (caso você seguiu a instalação do PostgreSQL via Docker como descrito acima, estas configurações já estarão corretas) no arquivo *config/dev.exs*:

```elixir
config :parcel_manager, ParcelManager.Infrastructure.Persistence.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "parcel_manager_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

Conforme as configurações acima estiverem corretamente aplicadas, podemos então executar nosso comando de setup do projeto, no qual irá criar um banco de dados, rodar todas as migrations e seeds, deixando o projeto apto a ser utilizado.

```bash
# Executa o setup do banco de dados e execução do seeds.exs
$ mix ecto.setup
```

Depois da conclusão do setup executado acima, podemos então subir nosso servidor Phoenix e utilizar nossa API rodando o comando abaixo:

```bash
# Sobe a API Phoenix
$ mix phx.server
```


## Endpoints
A API JSON deverá conter os seguintes endpoints:

> Aviso!
> Os JSONs de exemplo são apenas uma sugestão, você está livre para retornar os dados da forma que achar melhor
> desde que siga as regras definidas pelos endpoints.

### Create Parcel
Endpoint para criação de encomendas:

Caminho: `/api/parcel`
Método: `POST`
Exemplo de JSON de criação
```json
{
    "description": "Minha encomenda maneira 🛹",
    "source_id": "<location-id>",
    "destination_id": "<location-id>"
}
```

### Get Parcel
Endpoint para pegar informações de um `parcel`, retornando também as `locations` pelas quais o `parcel` passou.
As `locations` devem ser retornadas em **ordem de movimentação**, por exemplo, se um `parcel` passou pela
`Location A` e depois pela `Location B`, o retorno deverá ser: 
```json
[
    {"id": "<location-id>", "name": "Location A"},
    {"id": "<location-id>", "name": "Location B"}
]
```

Caminho: `/api/parcel/<parcel-id>`
Método: `GET`
Exemplo de retorno JSON
```json
{
    "id": "<parcel-id>",
    "description": "Minha encomenda maneira 🛹",
    "is_delivered": false,
    "source": {
        "id": "<location-id>",
        "name": "Location A"
    },
    "destination": {
        "id": "<location-id>",
        "name": "Location C"
    },
    "locations": [
        {"id": "<location-id>", "name": "Location A"},
        {"id": "<location-id>", "name": "Location B"}
    ]
}
```

### Transfer parcel
Endpoint para transferir um `parcel` para uma `location`. Esse endpoint deve apenas receber o `id` 
do `parcel` (definido no caminho do endpoint) e o `id` da `location` de transferência.

Caminho: `/api/parcel/<parcel-id>/transfer`
Método: `POST`
Exemplo de JSON de criação
```json
{
    "transfer_location_id": "<location-id>"
}
```

### Get Location
Endpoint para pegar informações de uma `location`, retornando também os `parcels` que estão **atualmente** nessa `location`.

Caminho: `/api/location/<location-id>`
Método: `GET`
```json
{
    "id": "<location-id>",
    "name": "Location B",
    "parcels": [
        {
            "id": "<parcel-id>",
            "description": "Minha encomenda maneira 🛹",
            "is_delivered": false,
            "source": {
                "id": "<location-id>",
                "name": "Location A"
            },
            "destination": {
                "id": "<location-id>",
                "name": "Location C"
            }
        }
    ]
}
```


#### Informações adicionais

Você poderá importar o arquivo *priv/endpoints.json* contendo a collection para utilizar a API via Postman.

#### Possíveis melhorias

Abaixo segue uma listagens de possíveis melhorias que poderiam ser implementadas no projeto:

  - Adicionar credo como linter;
  - Feature de envio de email a cada alteração de status de uma encomenda;
  - Observabilidade utilizando alarmística e gráficos de monitoramento;
  - Documentar funções e módulos;
  - Abrir endtrypoint assíncrono via mensageria para transferência de encomendas em lotes;
  - Dockerizar aplicação;
  - Pipeline de integração contínua com relatório de cobertura de testes e linter;
  - etc ...
