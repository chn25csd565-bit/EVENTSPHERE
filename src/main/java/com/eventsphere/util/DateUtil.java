package com.eventsphere.util;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtil {

    private static final SimpleDateFormat DISPLAY_FORMAT = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
    private static final SimpleDateFormat SHORT_FORMAT = new SimpleDateFormat("MMM dd, yyyy");
    private static final SimpleDateFormat INPUT_FORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");

    public static String formatDisplay(Timestamp ts) {
        if (ts == null) return "N/A";
        return DISPLAY_FORMAT.format(new Date(ts.getTime()));
    }

    public static String formatShort(Timestamp ts) {
        if (ts == null) return "N/A";
        return SHORT_FORMAT.format(new Date(ts.getTime()));
    }

    public static String formatInput(Timestamp ts) {
        if (ts == null) return "";
        return INPUT_FORMAT.format(new Date(ts.getTime()));
    }

    public static Timestamp parseInput(String input) {
        if (input == null || input.trim().isEmpty()) return null;
        try {
            Date parsed = INPUT_FORMAT.parse(input.trim());
            return new Timestamp(parsed.getTime());
        } catch (Exception e) {
            try {
                // Try standard yyyy-MM-dd HH:mm:ss
                SimpleDateFormat fallback = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                return new Timestamp(fallback.parse(input.trim()).getTime());
            } catch (Exception ex) {
                return null;
            }
        }
    }

    public static String getTimeRemaining(Timestamp target) {
        if (target == null) return "Ended";
        long diff = target.getTime() - System.currentTimeMillis();
        if (diff <= 0) return "Closed";

        long days = diff / (1000 * 60 * 60 * 24);
        long hours = (diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60);
        long mins = (diff % (1000 * 60 * 60)) / (1000 * 60);

        if (days > 0) {
            return days + "d " + hours + "h left";
        } else if (hours > 0) {
            return hours + "h " + mins + "m left";
        } else {
            return mins + " mins left";
        }
    }
}
