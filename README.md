# To be added by Noahsette

# Endpoints

Get all users 
> GET /api/users

Get a user
> GET /api/users/1

Create a user
> POST /api/users
json body
{
   "user_id": 1,
   "firstname": "Dalia",
   "surname": "Code",                 
   "birthday": "01-01-2000",
   "is_alive": True,
   "allow_criminal_record": True,
   "wants_extra_napkins": True
}

Update a user
> PUT /api/users/1
json body
{
   "firstname": "Dalia",
   "surname": "Code",
   "email": "iloveuber@uber.com",                   
   "password": "1234",
   "birthday": "01-01-2000",
   "is_alive": True,
   "allow_criminal_record": True,
   "wants_extra_napkins": True
}

Detele a user
> DELETE /api/users/1
