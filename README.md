# 📅 Data Modeling

This repository contains the setup for the data modeling modules in Weeks 1 and 2.
 
**Tech Stack**

- Git
- Postgres
- PSQL CLI
- Database management environment (DataGrip, DBeaver, VS Code with extensions, etc.)
- Docker, Docker Compose, and Docker Desktop

**TL;DR**

1. [Clone the repository](https://github.com/HazmiAmzar/Data-Modelling/blob/main/README.md).
2. [Start Postgres instance](https://github.com/HazmiAmzar/Data-Modelling?tab=readme-ov-file#1%EF%B8%8F%E2%83%A3run-postgres).
3. [Connect to Postgres](https://github.com/HazmiAmzar/Data-Modelling?tab=readme-ov-file#twoconnect-to-postgres-in-local-database-client) using your preferred database management tool.

For detailed instructions and more information, please refer to the step-by-step instructions below.

## 1️⃣**Run Postgres**

### 🐳 **Run Postgres and PGAdmin in Docker**

- Install Docker Desktop from **[here](https://www.docker.com/products/docker-desktop/)**.
- Start the Docker Compose container:    
    - If you're on Windows:
        
        ```bash
        docker compose up -d
        ```
        
- A folder named **`postgres-data`** will be created in the root of the repo. The data backing your Postgres instance will be saved here.
- You can check that your Docker Compose stack is running by either:
    - Going into Docker Desktop: you should see an entry there with a drop-down for each of the containers running in your Docker Compose stack.
    - Running **`docker ps -a`** and looking for the containers with the name **`postgres`**.
- If you navigate to **`http://localhost:5050`** you will be able to see the PGAdmin instance up and running and should be able to connect to the following server as details shown:
    
    <img src=".attachments/pgadmin-server.png" style="width:500px;"/> 


- When you're finished with your Postgres instance, you can stop the Docker Compose containers with:
    
    ```bash
    docker compose stop
    ```

## :two: **Connect to Postgres in Local Database Client**
- Some options for interacting with your Postgres instance:
    - DataGrip - JetBrains; 30-day free trial or paid version
    - VSCode built-in extension (there are a few of these).
    - PGAdmin.
    - Postbird.
    - Dbeaver
- Using your client of choice, follow the instructions to establish a new PostgreSQL connection.
    - The default username is **`postgres`** and corresponds to **`$POSTGRES_USER`** in your **`.env`**.
    - The default password is **`postgres`** and corresponds to **`$POSTGRES_PASSWORD`** in your **`.env`**.
    - The default database is **`postgres`** and corresponds to **`$POSTGRES_DB`** in your **`.env`**.
    - The default host is **`localhost`** or **`0.0.0.0`.** This is the IP address of the Docker container running the PostgreSQL instance.
    - The default port for Postgres is **`5432` .** This corresponds to the **`$CONTAINER_PORT`** variable in the **`.env`** file.
    
    &rarr; :bulb: You can edit these values by modifying the corresponding values in **`.env`**.
    
- If the test connection is successful, click "Finish" or "Save" to save the connection. You should now be able to use the database client to manage your PostgreSQL database locally.

### :rotating_light: **Need help loading tables?** :rotating_light:

> Refer to the instructions below to resolve the issue when the data dump fails to load tables, displaying the message `PostgreSQL Database directory appears to contain a database; Skipping initialization.`
## **🚨 Tables not loading!? 🚨**

- If you did the setup using Option 2 which is Docker option, and the tables are not in the database, another solution is to: 

1. Find the container id by running `docker ps` - under CONTAINER ID
2. Go inside the container by executing `docker exec -it <container_name_or_id> bash`
3. Run `pg_restore -U $POSTGRES_USER -d $POSTGRES_DB /docker-entrypoint-initdb.d/data.dump` 

## **Frequently Asked Questions (FAQs)**

1. **Not able to connect Postgres running on Docker?**
   - Please recheck details like host and port details.

2. **Throwing errors like connection refused even when all details are correct.**
   - Please check that the port(5432 or port you use) runs only docker service, not any other services.
     - Windows - use the command to check port availability in cmd ```netstat -ano | findstr :5432```
               - to kill rest of extra services use ```taskkill /PID <PID> /F```
     - Mac - use the command on terminal to check port availability ```lsof -i :5432```
           - to kill rest of extra services use ```kill -9 <PID>```
   

#### 💡 Additional Docker Make commands

- To restart the Postgres instance, you can run **`make restart`**.
- To see logs from the Postgres container, run **`make logs`**.
- To inspect the Postgres container, run **`make inspect`**.
- To find the port Postgres is running on, run **`make ip`**.
