# MediQueue - Tomcat 9 Version

Tomcat 9.0.122 compatible, no Maven.

## Requirements
- JDK 8+ (JDK 17 recommended)
- Apache Tomcat 9.x (tested target: 9.0.122)
- VS Code

## Demo accounts
- Patient: patient / patient123
- Doctor: doctor / doctor123
- Admin/Receptionist: admin / admin123

## Run
1. Open this folder in VS Code.
2. Set `TOMCAT_HOME` to your `apache-tomcat-9.0.122` folder.
3. Run `compile.bat`.
4. Copy the whole `MediQueue_Tomcat9` folder into Tomcat's `webapps` directory and rename it `MediQueue` if desired.
5. Start Tomcat with `bin\startup.bat`.
6. Open `http://localhost:8080/MediQueue/`.

## Notes
This is an educational demo. Queue/help data is stored in memory and resets when Tomcat restarts. Do not use real patient data.
