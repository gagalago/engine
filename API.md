## API

GET    /user                                           

PUT   /user/alive                                      

GET    /user/rooms                                     
GET    /user/rooms/:id                                 
POST   /user/rooms                                     
PUT    /user/rooms/:id                                 
DELETE /user/rooms/:id                                 

GET    /user/rooms/:room_id/messages                   
POST   /user/rooms/:room_id/messages                   
DELETE /user/rooms/:room_id/messages/:id               

POST   /user/rooms/:room_id/memberships                

PUT    /user/rooms/:room_id/membership                     

PUT    /user/rooms/:room_id/membership/unread-messages 

POST   /platform/users/:id/tokens                      
GET    /platform/users                                 
POST   /platform/users                                 
PUT    /platform/users/:id                             
DELETE /platform/users/:id                             
              
GET    /platform/rooms                                 
GET    /platform/rooms/:id                             
POST   /platform/rooms                                 
PUT    /platform/rooms/:id                             
DELETE /platform/rooms/:id                             

GET    /platform/rooms/room_id/users                   

POST   /platform/rooms/:room_id/messages               
DELETE /platform/rooms/:room_id/messages/:id           

POST   /platform/rooms/:roomId/users/:userId/membership
DELETE /platform/rooms/:roomId/users/:userId/membership

POST   /platform/messages-digests      
