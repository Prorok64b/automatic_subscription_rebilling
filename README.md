# How to run

postgres instance required.

```
rails db:create db:migrate db:seed

CASH_AMOUNT_ON_BANK_ACCOUNT='130' rails s
```

# Env variables

```
 # setup bank account balance, then you will be able to pay subscription which price is less or equal 130
CASH_AMOUNT_ON_BANK_ACCOUNT='130' rails s

# will make bank response with error, to emulate error scenario
BEHAVIOR='error' rails s

# will make bank response with insufficient funds, to emulate insufficient funds scenario
BEHAVIOR='insufficient_funds' rails s
```

# API call

```
POST http://127.0.0.1:3000/paymentIntents/create

body: { "subscription_id": 19 }
```
