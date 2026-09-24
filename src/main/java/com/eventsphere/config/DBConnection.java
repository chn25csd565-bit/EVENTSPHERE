package com.eventsphere.config;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {

    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    // MySQL Configuration
    private static final String MYSQL_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String MYSQL_URL = "jdbc:mysql://localhost:3306/eventsphere?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&createDatabaseIfNotExist=true";
    private static final String MYSQL_USER = "root";
    private static final String MYSQL_PASS = "root";

    // Embedded H2 Configuration (MySQL-compatible mode)
    private static final String H2_DRIVER = "org.h2.Driver";
    private static final String H2_DIR = "D:/dev_tools/eventsphere_db";
    private static final String H2_URL = "jdbc:h2:file:" + H2_DIR + "/eventsphere;MODE=MySQL;DATABASE_TO_LOWER=TRUE;DEFAULT_NULL_ORDERING=HIGH;AUTO_SERVER=TRUE";
    private static final String H2_USER = "sa";
    private static final String H2_PASS = "";

    private static boolean useH2Fallback = false;
    private static boolean isInitialized = false;

    static {
        initialize();
    }

    public static synchronized void initialize() {
        if (isInitialized) return;

        // Ensure H2 storage directory exists
        File h2DirFile = new File(H2_DIR);
        if (!h2DirFile.exists()) {
            h2DirFile.mkdirs();
        }

        // Test MySQL first
        try {
            Class.forName(MYSQL_DRIVER);
            try (Connection conn = DriverManager.getConnection(MYSQL_URL, MYSQL_USER, MYSQL_PASS)) {
                LOGGER.info("[EventSphere] Successfully connected to live MySQL database on port 3306.");
                useH2Fallback = false;
                checkAndSeedDatabase(conn);
                isInitialized = true;
                return;
            } catch (SQLException ex) {
                LOGGER.warning("[EventSphere] MySQL unavailable (" + ex.getMessage() + "). Switching to autonomous embedded mode...");
            }
        } catch (ClassNotFoundException e) {
            LOGGER.warning("[EventSphere] MySQL driver not found on classpath. Switching to embedded mode...");
        }

        // Fallback to embedded H2 in MySQL mode
        try {
            Class.forName(H2_DRIVER);
            try (Connection conn = DriverManager.getConnection(H2_URL, H2_USER, H2_PASS)) {
                LOGGER.info("[EventSphere] Autonomous embedded database active at: " + H2_DIR);
                useH2Fallback = true;
                checkAndSeedDatabase(conn);
                isInitialized = true;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[EventSphere] Critical database initialization failure: " + e.getMessage(), e);
        }
    }

    public static Connection getConnection() throws SQLException {
        if (!isInitialized) {
            initialize();
        }

        if (!useH2Fallback) {
            try {
                return DriverManager.getConnection(MYSQL_URL, MYSQL_USER, MYSQL_PASS);
            } catch (SQLException e) {
                LOGGER.warning("[EventSphere] MySQL connection lost. Falling back to embedded H2...");
                useH2Fallback = true;
            }
        }

        return DriverManager.getConnection(H2_URL, H2_USER, H2_PASS);
    }

    private static void checkAndSeedDatabase(Connection conn) {
        boolean tablesExist = false;
        try (Statement stmt = conn.createStatement()) {
            try (ResultSet rs = stmt.executeQuery("SELECT count(*) FROM users")) {
                if (rs.next()) {
                    tablesExist = true;
                    int count = rs.getInt(1);
                    LOGGER.info("[EventSphere] Existing database verified with " + count + " users.");
                }
            }
        } catch (SQLException e) {
            // Table does not exist
            tablesExist = false;
        }

        if (!tablesExist) {
            LOGGER.info("[EventSphere] Tables not found. Initializing schema and seed data...");
            runSqlFile(conn, "c:/Users/Joys/EVENTSPHERE/sql/schema_mysql.sql");
            runSqlFile(conn, "c:/Users/Joys/EVENTSPHERE/sql/seed_data.sql");
            LOGGER.info("[EventSphere] Database successfully initialized and seeded!");
        }
    }

    private static void runSqlFile(Connection conn, String filePath) {
        File file = new File(filePath);
        if (!file.exists()) {
            LOGGER.warning("[EventSphere] SQL file not found at " + filePath);
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file));
             Statement stmt = conn.createStatement()) {

            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.startsWith("--") || line.startsWith("//") || line.isEmpty()) {
                    continue;
                }
                int commentIdx = line.indexOf("--");
                if (commentIdx >= 0) {
                    line = line.substring(0, commentIdx).trim();
                }
                if (line.isEmpty()) {
                    continue;
                }
                sb.append(line).append(" ");
                if (line.endsWith(";")) {
                    String sql = sb.toString().trim();
                    sql = sql.substring(0, sql.length() - 1).trim(); // remove semicolon
                    if (!sql.isEmpty()) {
                        try {
                            stmt.execute(sql);
                        } catch (SQLException e) {
                            // Ignore harmless duplicate key errors on re-seed
                            if (!e.getMessage().toLowerCase().contains("already exists") &&
                                !e.getMessage().toLowerCase().contains("duplicate")) {
                                LOGGER.warning("[EventSphere] Error executing SQL: " + e.getMessage() + " | Query: " + sql);
                            }
                        }
                    }
                    sb.setLength(0);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[EventSphere] Failed to execute SQL file: " + filePath, e);
        }
    }

    public static boolean isEmbedded() {
        return useH2Fallback;
    }
}
