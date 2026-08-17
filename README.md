# Port Management System 

A comprehensive Java web application for managing port dock allocations, ship management, container handling, and cargo tracking. Built with Java Servlets, JSP, and MySQL.

## 🎯 Features

### Core Functionality
- **User Management** - Create, read, update, and delete user accounts with role-based access
- **Dock Management** - Manage port docks, capacity, and availability
- **Ship Management** - Track ships, schedules, and docking history
- **Container Management** - Monitor container inventory and tracking
- **Cargo Handling** - Track cargo operations and movements
- **Dock Allocation** - Allocate docks to ships with conflict prevention
- **Cargo Movement** - Record and track cargo movements
- **Dashboard** - Real-time system statistics and monitoring
- **Security Logs** - Audit trail for all operations
- **Profile Management** - User profile and settings management

### Security Features
- User authentication and session management
- Role-based access control (Admin, Port Manager, Ship Operator)
- Access denial protection for unauthorized users
- Security logging of all operations
- Password-protected accounts

## 🛠 Technology Stack

- **Language:** Java 8+
- **Web Framework:** Apache Tomcat 8.5.99
- **Presentation:** JSP (Java Server Pages)
- **Backend:** Java Servlets, JDBC
- **Database:** MySQL 8.0
- **Build:** Maven (pom.xml)
- **IDE:** Eclipse/VS Code

## 📋 Prerequisites

- Java Development Kit (JDK) 8 or higher
- Apache Tomcat 8.5 or higher
- MySQL Server 8.0 or higher
- Maven 3.6+ (optional, for dependency management)

## 📦 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/rowensamuel/port_management_system.git
cd port_management_system
```

### 2. Database Setup

Create MySQL database and tables:

```sql
CREATE DATABASE port_management;
USE port_management;

-- Create tables as per the database schema
-- Refer to your database initialization scripts
```

### 3. Build the Project

Using Maven:
```bash
mvn clean compile
mvn package
```

Or using javac:
```bash
javac -d build/classes -cp "lib/servlet-api.jar:src/main/java" src/main/java/**/*.java
```

### 4. Deploy to Tomcat

#### Option A: Manual Deployment
1. Copy `build/dock-allocation` folder to `TOMCAT_HOME/webapps/`
2. Copy compiled classes to `webapps/dock-allocation/WEB-INF/classes/`
3. Copy dependencies to `webapps/dock-allocation/WEB-INF/lib/`

#### Option B: WAR Deployment
```bash
mvn tomcat7:deploy
```

### 5. Start Tomcat

```bash
# Linux/Mac
$CATALINA_HOME/bin/catalina.sh start

# Windows
%CATALINA_HOME%\bin\catalina.bat start
```

## 🚀 Running the Application

1. Start MySQL Server
2. Start Apache Tomcat
3. Open browser and navigate to:
   ```
   http://localhost:8080/dock-allocation
   ```
4. Log in with your credentials (configure in database)

## 📁 Project Structure

```
port_management_system/
├── src/
│   └── main/
│       ├── java/
│       │   ├── controller/          # Servlet controllers
│       │   ├── model/               # Data models
│       │   ├── operations/          # Interface definitions
│       │   ├── operation_implementor/# Business logic
│       │   └── db_config/           # Database configuration
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── web.xml          # Deployment descriptor
│           │   └── lib/             # Dependencies
│           └── *.jsp                # JSP pages
├── build/                           # Compiled output
├── lib/                             # External libraries
├── pom.xml                          # Maven configuration
└── README.md                        # This file
```

## 📄 Key Files

### Controllers (Servlets)
- `LoginController.java` - User authentication
- `DashboardController.java` - Dashboard data
- `DockController.java` - Dock management operations
- `ShipController.java` - Ship management
- `ContainerController.java` - Container tracking
- `CargoHandlingController.java` - Cargo operations
- `DockAllocationController.java` - Dock allocation logic
- `UserController.java` - User management
- `SecurityLogController.java` - Security audit logs
- `ProfileController.java` - User profile management

### Models
- `User.java` - User entity
- `Dock.java` - Dock entity
- `Ship.java` - Ship entity
- `Container.java` - Container entity
- `Cargo.java` - Cargo entity
- `DockAllocation.java` - Allocation entity
- `CargoMovement.java` - Movement tracking
- `SecurityLog.java` - Audit log entity
- `DashboardData.java` - Dashboard statistics

### JSP Pages
- `login.jsp` - Login page
- `dashboard.jsp` - Main dashboard
- `dockmanagement.jsp` - Dock management
- `shipmanagement.jsp` - Ship management
- `containermanagement.jsp` - Container management
- `cargohandling.jsp` - Cargo operations
- `dockallocation.jsp` - Allocation interface
- `usermanagement.jsp` - User management
- `profile.jsp` - User profile
- `securitylog.jsp` - Audit logs
- `accessdenied.jsp` - Access denial page

## 🔐 User Roles

| Role | Permissions |
|------|-------------|
| Admin | Full system access, user management, system configuration |
| Port Manager | Dock allocation, ship scheduling, resource management |
| Ship Operator | View dock allocations, cargo handling, profile management |

## 🔌 API Routes

### Authentication
- `GET/POST /login` - User login
- `GET/POST /logout` - User logout
- `GET/POST /profile` - Profile management

### Dock Operations
- `GET/POST /dockmanagement` - Dock CRUD operations
- `GET/POST /dockallocation` - Allocate docks to ships

### Ship Management
- `GET/POST /shipmanagement` - Ship operations

### Container Management
- `GET/POST /containermanagement` - Container tracking

### Cargo Handling
- `GET/POST /cargohandling` - Cargo operations

### System
- `GET /dashboard` - Dashboard statistics
- `GET /securitylog` - View audit logs
- `GET /usermanagement` - User administration

## 🐛 Troubleshooting

### Servlet API Not Found
**Error:** `javax.servlet cannot be resolved`
**Solution:** Ensure servlet-api.jar is in classpath and .classpath file includes Tomcat library path

### Database Connection Failed
**Error:** `Connection refused` or `No database selected`
**Solution:** 
1. Verify MySQL is running
2. Check database credentials in DBConfig.java
3. Ensure database and tables are created

### Application Not Accessible
**Error:** `404 Not Found`
**Solution:**
1. Verify application is deployed in `TOMCAT_HOME/webapps/dock-allocation/`
2. Check Tomcat logs in `TOMCAT_HOME/logs/catalina.log`
3. Restart Tomcat

## 📝 Configuration

### Database Configuration
Edit `src/main/java/db_config/DBConfig.java`:

```java
private static final String URL = "jdbc:mysql://localhost:3306/port_management";
private static final String USER = "root";
private static final String PASSWORD = "your_password";
```

### Server Configuration
Edit `src/main/webapp/WEB-INF/web.xml` for:
- Welcome pages
- Error pages
- Session timeouts
- MIME types

## 🔍 Development

### Eclipse Setup
1. Import project as existing Java project
2. Right-click → Project Facets → Convert to faceted form
3. Add Tomcat 8.5 runtime
4. Update .classpath with servlet-api.jar path

### VS Code Setup
1. Install Java Extension Pack
2. Update .classpath with library paths
3. Configure launch.json for debugging
4. Use Maven for building

## 📦 Dependencies

### Maven (pom.xml)
```xml
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>servlet-api</artifactId>
    <version>2.5</version>
    <scope>provided</scope>
</dependency>
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <version>9.0.0</version>
</dependency>
```

### Manual JAR Files
- `servlet-api.jar` - Tomcat library
- `mysql-connector-j-9.6.0.jar` - MySQL driver

## 🧪 Testing

### Unit Testing
Test individual servlets and models:
```bash
# Recommended: Create test suite in src/test/java
```

### Integration Testing
Test end-to-end workflows with a running Tomcat instance

## 📚 Documentation

- Architecture: Layered (Servlet → Implementor → Operations → Model)
- Database: Relational (MySQL)
- Authentication: Session-based
- Authorization: Role-based access control (RBAC)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

**Rowen Samuel**
- GitHub: [@rowensamuel](https://github.com/rowensamuel)
- Repository: [port_management_system](https://github.com/rowensamuel/port_management_system)

## 📞 Support

For issues, questions, or suggestions:
1. Open an Issue on GitHub
2. Check existing issues and pull requests
3. Review documentation and troubleshooting section

## 🎉 Acknowledgments

- Apache Tomcat team for excellent Java web server
- MySQL community for reliable database
- Java community for comprehensive libraries

---

**Last Updated:** August 17, 2026  
**Version:** 1.0.0  
**Status:** ✅ Running and Deployed
