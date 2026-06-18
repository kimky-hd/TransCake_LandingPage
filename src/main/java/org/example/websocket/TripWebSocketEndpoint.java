package org.example.websocket;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

@ServerEndpoint("/ws/trip")
public class TripWebSocketEndpoint {
    private static final Logger LOGGER = Logger.getLogger(TripWebSocketEndpoint.class.getName());
    
    // Lưu trữ session theo định dạng: "role:userId" -> Session
    // Ví dụ: "driver:5" -> Session
    private static final Map<String, Session> activeSessions = new ConcurrentHashMap<>();
    private static final Gson gson = new Gson();

    @OnOpen
    public void onOpen(Session session) {
        LOGGER.info("New WebSocket connection: " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        try {
            JsonObject json = gson.fromJson(message, JsonObject.class);
            if (json.has("action") && "auth".equals(json.get("action").getAsString())) {
                String role = json.get("role").getAsString();
                Long userId = json.get("userId").getAsLong();
                String key = role + ":" + userId;
                
                // Lưu session
                session.getUserProperties().put("authKey", key);
                activeSessions.put(key, session);
                LOGGER.info("User authenticated on WS: " + key);
            }
        } catch (JsonSyntaxException | NullPointerException e) {
            LOGGER.warning("Invalid WebSocket message: " + message);
        }
    }

    @OnClose
    public void onClose(Session session) {
        String key = (String) session.getUserProperties().get("authKey");
        if (key != null) {
            activeSessions.remove(key);
            LOGGER.info("WebSocket connection closed for user: " + key);
        } else {
            LOGGER.info("WebSocket connection closed: " + session.getId());
        }
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        LOGGER.log(Level.SEVERE, "WebSocket error on session " + session.getId(), throwable);
    }

    /**
     * Gửi tin nhắn tới một user cụ thể
     */
    public static void sendMessageToUser(String role, Long userId, String action, JsonObject payload) {
        String key = role + ":" + userId;
        Session session = activeSessions.get(key);
        if (session != null && session.isOpen()) {
            JsonObject message = new JsonObject();
            message.addProperty("action", action);
            if (payload != null) {
                message.add("payload", payload);
            }
            try {
                session.getBasicRemote().sendText(gson.toJson(message));
            } catch (IOException e) {
                LOGGER.log(Level.SEVERE, "Failed to send WS message to " + key, e);
            }
        }
    }

    /**
     * Gửi tin nhắn tới TẤT CẢ driver đang online
     */
    public static void broadcastToAllDrivers(String action, JsonObject payload) {
        JsonObject message = new JsonObject();
        message.addProperty("action", action);
        if (payload != null) {
            message.add("payload", payload);
        }
        String messageStr = gson.toJson(message);

        for (Map.Entry<String, Session> entry : activeSessions.entrySet()) {
            if (entry.getKey().startsWith("driver:")) {
                Session session = entry.getValue();
                if (session.isOpen()) {
                    try {
                        session.getBasicRemote().sendText(messageStr);
                    } catch (IOException e) {
                        LOGGER.log(Level.SEVERE, "Failed to broadcast to " + entry.getKey(), e);
                    }
                }
            }
        }
    }
}
