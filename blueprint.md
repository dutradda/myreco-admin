FORMAT: 1A

# MyReco API
MyReco calls examples

# Group Users
Users related requests

## User Test [/users/{email}]

### Retrieve Test User [GET]
+ Parameters
    + email: test@test.com (string) - The test user email
+ Response 200 (application/json)
    {
        "email": "test@test.com",
        "stores": [{"name": "Test", "country": "C Test", "id": 1}]
    }

### Retrieve Test User headers [OPTIONS]
+ Parameters
    + email: test@test.com (string) - The test user email
+ Response 200
    + Headers
        Access-Control-Allow-Origin *
        Access-Control-Allow-Headers Authorization, Content-Type


# Group Placements

## All Placements [/placements]

### Retrieve All Placements headers [OPTIONS]
+ Response 200
    + Headers
        Access-Control-Allow-Origin *
        Access-Control-Allow-Headers Authorization, Content-Type

### Retrieve All Placements [GET]
+ Response 200 (application/json)
    [{
        "name": "Placement 1",
        "hash": "123abc",
        "variations": [{
            "id": 1,
            "name": "Variaton 1.1",
            "weight": 50.0
        },{
            "id": 2,
            "name": "Variation 1.2",
            "weight": 50.0
        }]
    },{
        "name": "Placement 2",
        "hash": "456def",
        "variations": [{
            "id": 3,
            "name": "Variaton 2.1",
            "weight": 50.0
        },{
            "id": 4,
            "name": "Variation 2.2",
            "weight": 50.0
        }]
    }]


## One Placement [/placements/{hash}]

### Retrieve Placement 1 [GET]
+ Parameters
    + hash: 123abc (string) - The placement hash
+ Response 200 (application/json)
    {
        "name": "Placement 1",
        "hash": "123abc",
        "variations": [{
            "id": 1,
            "name": "Variaton 1.1",
            "weight": 50.0
        },{
            "id": 2,
            "name": "Variation 1.2",
            "weight": 50.0
        }]
    }

### Retrieve Placement 1 headers [OPTIONS]
+ Parameters
    + hash: 123abc (string) - The placement hash
+ Response 200
    + Headers
        Access-Control-Allow-Origin *
        Access-Control-Allow-Headers Authorization, Content-Type


### Retrieve Placement 2 [GET]
+ Parameters
    + hash: 456def (string) - The placement hash
+ Response 200 (application/json)
    {
        "name": "Placement 2",
        "hash": "456def",
        "variations": [{
            "id": 3,
            "name": "Variaton 2.1",
            "weight": 50.0
        },{
            "id": 4,
            "name": "Variation 2.2",
            "weight": 50.0
        }]
    }

### Retrieve Placement 2 headers [OPTIONS]
+ Parameters
    + hash: 456def (string) - The placement hash
+ Response 200
    + Headers
        Access-Control-Allow-Origin *
        Access-Control-Allow-Headers Authorization, Content-Type


# POST /placements
+ Response 201 (application/json)
    [{
        "name": "Placement 2",
        "hash": "456def",
        "variations": [{
            "id": 3,
            "name": "Variaton 2.1",
            "weight": 50.0
        },{
            "id": 4,
            "name": "Variation 2.2",
            "weight": 50.0
        }]
    }]


# PATCH /placements/123abc
+ Response 200 (application/json)
    {
        "name": "Placement 1",
        "hash": "123abc",
        "variations": [{
            "id": 1,
            "name": "Variaton 1.1",
            "weight": 50.0
        },{
            "id": 2,
            "name": "Variation 1.2",
            "weight": 50.0
        }]
    }


# PATCH /placements/456def
+ Response 200 (application/json)
    {
        "name": "Placement 2",
        "hash": "456def",
        "variations": [{
            "id": 3,
            "name": "Variaton 2.1",
            "weight": 50.0
        },{
            "id": 4,
            "name": "Variation 2.2",
            "weight": 50.0
        }]
    }
