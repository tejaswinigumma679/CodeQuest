
package com.codequest.util;

public class GenerateAdminHash {

    public static void main(String[] args) {

        try {
            String password = "CodeQuest@143";

            String hash = PasswordUtil.hashPassword(password);

            System.out.println("Admin password hash:");
            System.out.println(hash);

        } catch (Exception e) {
            System.out.println("Error generating password hash:");
            e.printStackTrace();
        }
    }
}
