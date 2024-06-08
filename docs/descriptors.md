# Descriptors

A descriptor in the context of the Lesli Security gem is a collection of rails controllers and actions paths, this means we store in the database the route of every controller and their corresponding actions registered in the route.rb file.

Example: 


| Controller | Action | Allowed |
|---	|---	|---    |
| Users | index | true  |
| Users | show  | true  |
| Users | create | true |
| Users | edit   | true |
| Users | delete | false |

Of course to have a well designed and a good integrity in the database we have to split this into multiples tables:

- System controllers: All the controllers registered in the routes.rb file.
- System controller actions: The actions available in every controller.
- Descriptors: Just the head of the descriptor map.
- Descriptor privileges: The relation and status between controller, action and descriptor.


```mermaid
erDiagram
    system_controllers {

    }

    system_controller_actions {

    }

    descriptors {

    }

    descriptor_privileges {

    }

    system_controllers ||--o{ system_controller_actions : has
    descriptor_privileges ||--|| system_controller_actions : has
    descriptors ||--o{ descriptor_privileges : has
```

Using this database structure we can create a view to manage the collection of controllers/actions that belongs to a descriptor:

<img src="./images/descriptors-index.excalidraw.png">
