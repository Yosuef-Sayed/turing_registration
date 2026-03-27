
# Ticket Check API Documentation

This document provides details about the **Ticket Check API**, which is used to validate and mark tickets as scanned.

## **POST /api/ticket/check** – Mark a Ticket as Scanned (Idempotent)

### **Description**:
This endpoint is used to **mark a ticket as scanned**. It ensures that a ticket can only be scanned once, and once it's marked as scanned, the backend will store the timestamp for when the ticket was scanned.

### **Method**:
`POST`

### **URL**:
`/api/ticket/check`

### **Request Body**:
The request must include a `code` parameter, which represents the **ticket code**. The ticket code can either be:
- **`merchantOrderId`** (a unique identifier for the order).
- **`ticketCode`** (a unique code representing an individual ticket).
- **`ticketCodes`** (an array containing multiple ticket codes for a multi-ticket purchase).

#### **Example Request**:
```json
{
  "code": "Z6oO6UVsWUevL1ih5zLr"
}
```

### **Response**:

#### **Success (200 OK)**:
If the ticket is valid and not already scanned, the response will indicate that the ticket has been successfully checked in.

```json
{
  "ok": true,
  "message": "checked in",
  "user": {
    "name": "John Doe",
    "email": "john.doe@example.com"
  },
  "ticketCode": "Z6oO6UVsWUevL1ih5zLr"
}
```

#### **Failure - Ticket Already Scanned (409 Conflict)**:
If the ticket has already been scanned, the response will indicate this and provide the timestamp when it was scanned.

```json
{
  "ok": false,
  "message": "already scanned",
  "scannedAt": "2026-03-27T12:34:56Z"
}
```

#### **Failure - Ticket Not Found (404 Not Found)**:
If the ticket is not found in Firestore, the response will indicate that the ticket was not found.

```json
{
  "error": "ticket not found"
}
```

#### **Error Response (500 Internal Server Error)**:
If there is any error while processing the request, such as a server-side issue, a `500` response will be returned.

```json
{
  "error": "Error message here"
}
```

### **Workflow**:
1. The frontend sends a **POST** request with the `code` parameter (the ticket code).
2. The backend searches Firestore for the ticket using the `merchantOrderId`, `ticketCode`, or `ticketCodes` array.
3. If the ticket is found and not already scanned, the backend updates the Firestore document, marking the ticket as scanned by updating `scannedMap` or `scannedAt`.
4. The backend responds with the updated status of the ticket, including the timestamp when it was scanned.
5. If the ticket is already scanned, the backend responds with a message indicating the ticket is already scanned, along with the `scannedAt` timestamp.

---

## **GET /api/ticket/check** – Validate and Check If the QR Ticket Has Been Scanned

### **Description**:
This endpoint is used to **validate** whether a ticket (represented by a QR code) has been **scanned** or not. It checks the Firestore database to see if the provided ticket code has been scanned.

### **Method**:
`GET`

### **URL**:
`/api/ticket/check`

### **Query Parameters**:
- **`code`** (required): The **ticket code** to check.
  - This can be the **`merchantOrderId`**, **`ticketCode`**, or **part of the `ticketCodes` array** (if it's a multi-ticket purchase).

#### **Example Request**:
```
GET /api/ticket/check?code=Z6oO6UVsWUevL1ih5zLr
```

### **Response**:

#### **Success (200 OK)**:
If the ticket is found and the scanned status is retrieved, the response will include the scanned status and timestamp.

```json
{
  "ok": true,
  "found": true,
  "scanned": true,
  "scannedAt": "2026-03-27T12:34:56Z",
  "user": {
    "name": "John Doe",
    "email": "john.doe@example.com"
  },
  "ticketCode": "Z6oO6UVsWUevL1ih5zLr"
}
```

- **`scanned`**: `true` if the ticket has already been scanned, `false` otherwise.
- **`scannedAt`**: The timestamp of when the ticket was scanned, or `null` if not scanned.

#### **Failure - Ticket Not Found (404 Not Found)**:
If the ticket is not found in Firestore, the response will indicate that the ticket was not found.

```json
{
  "error": "ticket not found"
}
```

#### **Error Response (500 Internal Server Error)**:
If there is an error processing the request, a `500` status code will be returned.

```json
{
  "error": "Error message here"
}
```

### **Workflow**:
1. The frontend sends a **GET** request with the `code` parameter (the ticket code).
2. The backend searches Firestore for the ticket using the `merchantOrderId`, `ticketCode`, or `ticketCodes` array.
3. If the ticket is found:
   - It checks if the ticket has been scanned using `scannedMap` or `scannedAt`.
   - If found, it returns the `scanned` status and the timestamp (`scannedAt`).
4. If the ticket is not found, the backend responds with a `404` error indicating that the ticket was not found.
5. If the ticket has been scanned, the backend responds with the appropriate status and the scan timestamp.

---

### **Common Flow for Both Endpoints**:

- **Step 1**: The frontend sends a request (`GET` or `POST`) with a `code` (ticket code).
- **Step 2**: The backend queries Firestore to find the document associated with the ticket using the `code` (either `merchantOrderId`, `ticketCode`, or `ticketCodes` array).
- **Step 3**: The backend checks if the ticket has been scanned (`scannedMap` or `scannedAt`).
  - **For GET**: The backend simply returns the ticket's scan status.
  - **For POST**: The backend marks the ticket as scanned and returns the updated status.
- **Step 4**: If the ticket is not found, the backend responds with a `404` error.
- **Step 5**: The response includes the ticket scan status and timestamp (`scannedAt`).

### **Summary of Both Endpoints**:
- **GET /api/ticket/check**: Used to **validate** if a ticket has been scanned.
- **POST /api/ticket/check**: Used to **mark** a ticket as scanned and update the Firestore record.

Both endpoints provide a way to track and manage ticket scans, preventing multiple scans of the same ticket.
