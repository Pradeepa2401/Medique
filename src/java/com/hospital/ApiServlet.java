package com.hospital;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ApiServlet extends HttpServlet {

    private void json(
            HttpServletResponse response,
            String data)
            throws IOException {

        response.setContentType(
                "application/json;charset=UTF-8"
        );

        response.getWriter().print(data);
    }


    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse res)
            throws IOException {

        String action =
                req.getParameter("action");


        if (action == null ||
                action.isEmpty()) {

            action = "queue";
        }


        switch (action) {


            /*
             * LIVE QUEUE
             */

            case "queue":

                sendQueue(res);

                break;


            /*
             * PATIENT DATABASE
             */

            case "patients":

                sendPatients(res);

                break;


            /*
             * DEPARTMENTS
             */

            case "departments":

                json(
                    res,

                    "{\"items\":[" +

                    "{\"id\":\"cardio\",\"name\":\"Cardiology\"}," +

                    "{\"id\":\"neuro\",\"name\":\"Neurology\"}," +

                    "{\"id\":\"ortho\",\"name\":\"Orthopedics\"}," +

                    "{\"id\":\"general\",\"name\":\"General Medicine\"}," +

                    "{\"id\":\"pediatrics\",\"name\":\"Pediatrics\"}," +

                    "{\"id\":\"dermatology\",\"name\":\"Dermatology\"}," +

                    "{\"id\":\"ent\",\"name\":\"ENT\"}," +

                    "{\"id\":\"ophthalmology\",\"name\":\"Ophthalmology\"}," +

                    "{\"id\":\"gynecology\",\"name\":\"Gynecology\"}," +

                    "{\"id\":\"dentistry\",\"name\":\"Dentistry\"}" +

                    "]}"
                );

                break;


            /*
             * DOCTORS
             */

            case "doctors":

                json(
                    res,

                    "{\"items\":[" +

                    "{\"id\":\"d1\",\"name\":\"Dr. Ananya\",\"department\":\"Cardiology\"}," +

                    "{\"id\":\"d2\",\"name\":\"Dr. Vikram\",\"department\":\"Cardiology\"}," +

                    "{\"id\":\"d3\",\"name\":\"Dr. Rahul\",\"department\":\"Neurology\"}," +

                    "{\"id\":\"d4\",\"name\":\"Dr. Meera\",\"department\":\"Neurology\"}," +

                    "{\"id\":\"d5\",\"name\":\"Dr. Priya\",\"department\":\"Orthopedics\"}," +

                    "{\"id\":\"d6\",\"name\":\"Dr. Arjun\",\"department\":\"Orthopedics\"}," +

                    "{\"id\":\"d7\",\"name\":\"Dr. Kumar\",\"department\":\"General Medicine\"}," +

                    "{\"id\":\"d8\",\"name\":\"Dr. Sneha\",\"department\":\"General Medicine\"}," +

                    "{\"id\":\"d9\",\"name\":\"Dr. Kavya\",\"department\":\"Pediatrics\"}," +

                    "{\"id\":\"d10\",\"name\":\"Dr. Rohan\",\"department\":\"Dermatology\"}," +

                    "{\"id\":\"d11\",\"name\":\"Dr. Divya\",\"department\":\"ENT\"}," +

                    "{\"id\":\"d12\",\"name\":\"Dr. Neha\",\"department\":\"Ophthalmology\"}," +

                    "{\"id\":\"d13\",\"name\":\"Dr. Anjali\",\"department\":\"Gynecology\"}," +

                    "{\"id\":\"d14\",\"name\":\"Dr. Swetha\",\"department\":\"Dentistry\"}" +

                    "]}"
                );

                break;


            /*
             * HELP REQUESTS
             */

            case "help":

                sendHelp(res);

                break;


            default:

                sendQueue(res);

                break;

        }

    }


    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse res)
            throws IOException {

        String action =
                req.getParameter("action");


        if (action == null ||
                action.isEmpty()) {

            action = "queue";
        }


        switch (action) {


            /*
             * GENERATE PATIENT TOKEN
             */

            case "token":

                String patient =
                        req.getParameter("patient");

                String name =
                        req.getParameter("name");

                String ageText =
                        req.getParameter("age");

                String phone =
                        req.getParameter("phone");

                String gender =
                        req.getParameter("gender");

                String address =
                        req.getParameter("address");

                String department =
                        req.getParameter("department");

                String doctor =
                        req.getParameter("doctor");


                int age = 0;


                try {

                    if (
                        ageText != null &&
                        !ageText.isEmpty()
                    ) {

                        age =
                            Integer.parseInt(
                                ageText
                            );

                    }

                } catch (
                        NumberFormatException e) {

                    age = 0;

                }


                int token =
                        TokenStore.book(
                            patient,
                            name,
                            age,
                            phone,
                            gender,
                            address,
                            department,
                            doctor
                        );


                req.getSession()
                        .setAttribute(
                            "token",
                            token
                        );


                json(
                    res,
                    "{\"token\":" +
                    token +
                    "}"
                );


                break;


            /*
             * SIMPLE BOOKING
             */

            case "book":

                int bookedToken =
                        TokenStore.book();


                req.getSession()
                        .setAttribute(
                            "token",
                            bookedToken
                        );


                json(
                    res,
                    "{\"token\":" +
                    bookedToken +
                    "}"
                );


                break;


            /*
             * CALL NEXT PATIENT
             */

            case "next":

                Integer next =
                        TokenStore.next();


                if (next == null) {

                    json(
                        res,
                        "{\"message\":\"No waiting patients\"}"
                    );

                } else {

                    json(
                        res,

                        "{\"message\":\"Calling token " +
                        next +
                        "\",\"currentToken\":" +
                        next +
                        "}"
                    );

                }


                break;


            /*
             * COMPLETE PATIENT
             */

            case "complete":

                Integer completed =
                        TokenStore.complete();


                json(
                    res,

                    "{\"message\":\"Consultation marked complete.\"," +
                    "\"token\":" +
                    (
                        completed == null
                        ? 0
                        : completed
                    ) +
                    "}"
                );


                break;


            /*
             * HELP
             */

            case "help":

                String message =
                        req.getParameter(
                            "message"
                        );


                TokenStore.addHelp(
                    message
                );


                json(
                    res,
                    "{\"message\":\"Help request sent to reception.\"}"
                );


                break;


            /*
             * RESET QUEUE
             */

            case "reset":

                TokenStore.reset();


                json(
                    res,
                    "{\"message\":\"Queue reset successfully.\"}"
                );


                break;


            default:

                json(
                    res,
                    "{\"message\":\"Unknown action\"}"
                );


                break;

        }

    }


    /*
     * SEND LIVE QUEUE
     */

    private void sendQueue(
            HttpServletResponse res)
            throws IOException {


        List<TokenStore.PatientToken> patients =
                TokenStore.patients();


        StringBuilder output =
                new StringBuilder();


        output.append("{");


        output.append(
            "\"currentToken\":" +
            TokenStore.current()
        );


        output.append(",");


        output.append(
            "\"waitingCount\":" +
            TokenStore.waiting()
        );


        output.append(",");


        output.append(
            "\"waiting\":" +
            TokenStore.waiting()
        );


        output.append(",");


        output.append("\"tokens\":[");


        for (
            int i = 0;
            i < patients.size();
            i++
        ) {


            TokenStore.PatientToken p =
                    patients.get(i);


            if (i > 0) {

                output.append(",");

            }


            output.append("{");


            output.append(
                "\"token\":" +
                p.token
            );


            output.append(",");


            output.append(
                "\"patient\":\"" +
                esc(p.patient) +
                "\""
            );


            output.append(",");


            output.append(
                "\"name\":\"" +
                esc(p.name) +
                "\""
            );


            output.append(",");


            output.append(
                "\"age\":" +
                p.age
            );


            output.append(",");


            output.append(
                "\"phone\":\"" +
                esc(p.phone) +
                "\""
            );


            output.append(",");


            output.append(
                "\"gender\":\"" +
                esc(p.gender) +
                "\""
            );


            output.append(",");


            output.append(
                "\"address\":\"" +
                esc(p.address) +
                "\""
            );


            output.append(",");


            output.append(
                "\"department\":\"" +
                esc(p.department) +
                "\""
            );


            output.append(",");


            output.append(
                "\"doctor\":\"" +
                esc(p.doctor) +
                "\""
            );


            output.append(",");


            output.append(
                "\"status\":\"" +
                esc(p.status) +
                "\""
            );


            output.append("}");

        }


        output.append("]");

        output.append("}");


        json(
            res,
            output.toString()
        );

    }


    /*
     * SEND PATIENT DATABASE
     */

    private void sendPatients(
            HttpServletResponse res)
            throws IOException {


        List<TokenStore.PatientToken> patients =
                TokenStore.patients();


        StringBuilder output =
                new StringBuilder();


        output.append("{");

        output.append("\"patients\":[");


        for (
            int i = 0;
            i < patients.size();
            i++
        ) {


            TokenStore.PatientToken p =
                    patients.get(i);


            if (i > 0) {

                output.append(",");

            }


            output.append("{");


            output.append(
                "\"token\":" +
                p.token
            );


            output.append(",");


            output.append(
                "\"patient\":\"" +
                esc(p.patient) +
                "\""
            );


            output.append(",");


            output.append(
                "\"name\":\"" +
                esc(p.name) +
                "\""
            );


            output.append(",");


            output.append(
                "\"age\":" +
                p.age
            );


            output.append(",");


            output.append(
                "\"phone\":\"" +
                esc(p.phone) +
                "\""
            );


            output.append(",");


            output.append(
                "\"gender\":\"" +
                esc(p.gender) +
                "\""
            );


            output.append(",");


            output.append(
                "\"address\":\"" +
                esc(p.address) +
                "\""
            );


            output.append(",");


            output.append(
                "\"department\":\"" +
                esc(p.department) +
                "\""
            );


            output.append(",");


            output.append(
                "\"doctor\":\"" +
                esc(p.doctor) +
                "\""
            );


            output.append(",");


            output.append(
                "\"status\":\"" +
                esc(p.status) +
                "\""
            );


            output.append("}");

        }


        output.append("]");

        output.append("}");


        json(
            res,
            output.toString()
        );

    }


    /*
     * SEND HELP REQUESTS
     */

    private void sendHelp(
            HttpServletResponse res)
            throws IOException {


        List<String> requests =
                TokenStore.help();


        StringBuilder output =
                new StringBuilder();


        output.append("{");

        output.append("\"items\":[");


        for (
            int i = 0;
            i < requests.size();
            i++
        ) {


            if (i > 0) {

                output.append(",");

            }


            output.append("{");


            output.append(
                "\"message\":\"" +
                esc(
                    requests.get(i)
                ) +
                "\""
            );


            output.append(",");


            output.append(
                "\"reply\":\"Waiting for receptionist reply\""
            );


            output.append("}");

        }


        output.append("]");

        output.append("}");


        json(
            res,
            output.toString()
        );

    }


    /*
     * ESCAPE JSON TEXT
     */

    private String esc(
            String value) {


        if (value == null) {

            return "";

        }


        return value

                .replace(
                    "\\",
                    "\\\\"
                )

                .replace(
                    "\"",
                    "\\\""
                )

                .replace(
                    "\r",
                    ""
                )

                .replace(
                    "\n",
                    " "
                );

    }

}