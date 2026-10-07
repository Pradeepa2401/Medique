package com.hospital;

import java.util.*;

public class TokenStore {

    public static class PatientToken {

        public int token;
        public String patient;
        public String name;
        public int age;
        public String phone;
        public String gender;
        public String address;
        public String department;
        public String doctor;
        public String status;

        public PatientToken(
                int token,
                String patient,
                String name,
                int age,
                String phone,
                String gender,
                String address,
                String department,
                String doctor) {

            this.token = token;
            this.patient = patient;
            this.name = name;
            this.age = age;
            this.phone = phone;
            this.gender = gender;
            this.address = address;
            this.department = department;
            this.doctor = doctor;
            this.status = "WAITING";
        }
    }


    private static int next = 1;

    private static int current = 0;

    private static final List<PatientToken> tokens =
            new ArrayList<>();

    private static final List<String> help =
            new ArrayList<>();


    /*
     * Old/simple booking method.
     * Kept so the other pages continue working.
     */
    public static synchronized int book() {

        int token = next++;

        PatientToken p = new PatientToken(
                token,
                "patient",
                "Patient",
                0,
                "",
                "",
                "",
                "",
                ""
        );

        tokens.add(p);

        return token;
    }


    /*
     * New booking method used by Patient Details form.
     */
    public static synchronized int book(
            String patient,
            String name,
            int age,
            String phone,
            String gender,
            String address,
            String department,
            String doctor) {

        int token = next++;

        PatientToken p = new PatientToken(
                token,
                patient,
                name,
                age,
                phone,
                gender,
                address,
                department,
                doctor
        );

        tokens.add(p);

        return token;
    }


    public static synchronized int current() {

        return current;
    }


    public static synchronized int waiting() {

        int count = 0;

        for (PatientToken p : tokens) {

            if ("WAITING".equals(p.status)) {
                count++;
            }
        }

        return count;
    }


    /*
     * Doctor calls the next patient.
     */
    public static synchronized Integer next() {

        for (PatientToken p : tokens) {

            if ("WAITING".equals(p.status)) {

                p.status = "CALLED";

                current = p.token;

                return current;
            }
        }

        return null;
    }


    /*
     * Complete current consultation.
     */
    public static synchronized Integer complete() {

        for (PatientToken p : tokens) {

            if (p.token == current) {

                p.status = "COMPLETED";

                break;
            }
        }

        return current;
    }


    /*
     * Returns all patient records.
     */
    public static synchronized List<PatientToken> patients() {

        return new ArrayList<>(tokens);
    }


    /*
     * Returns waiting token numbers.
     * Kept for compatibility with older code.
     */
    public static synchronized List<Integer> queue() {

        List<Integer> result =
                new ArrayList<>();

        for (PatientToken p : tokens) {

            if ("WAITING".equals(p.status)) {

                result.add(p.token);
            }
        }

        return result;
    }


    public static synchronized void addHelp(String message) {

        if (message != null && !message.trim().isEmpty()) {

            help.add(message);
        }
    }


    public static synchronized List<String> help() {

        return new ArrayList<>(help);
    }


    /*
     * Reset queue.
     */
    public static synchronized void reset() {

        next = 1;

        current = 0;

        tokens.clear();

        help.clear();
    }
}