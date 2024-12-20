# 📝 API user registration

A REST API endpoint that manages user registration.

## 👨‍💻 Overview

This API endpoint provides a solution for registrating users with unique 3-letter pseudos (AAA to ZZZ) using a pre-allocated table approach.

## ⚙️ Technical Approach

### Pre-allocated Table Strategy

We use a dedicated `available_pseudos` table that stores all possible 3-letter combinations (17,576 combinations from AAA to ZZZ). This approach offers:

- Constant time O(log n) pseudo allocation
- Predictable performance
- Minimal database operations : 2 (SELECT + DELETE)

## 🕵️ Setup

### Requirements
- Ruby 3.3
- Rails 7.1.5
- PostgreSQL

### Installation

1. Clone the repository
2. Install dependencies : `bundle install`
3. Setup database : `rails db:create db:migrate`
4. Seed `available_pseudos` table : `rake pseudo:generate`
5. Run server : `rails server`

## 📚 API Documentation

### Create User

```http
POST /api/v1/signup
```

**Request Body:**
```json
{
  "user": {
    "pseudo": "XWC"
  }
}
```

**Response:**
```json
{
  "pseudo": "XWC",
  "message": "User created successfully"
}
```
## ✅ Tests
To run the test suite using RSpec

```sh
bundle exec rspec
```