// file: functions/src/index.ts

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// Use `require` for Razorpay as it doesn't have official TypeScript types.
// This is a common and perfectly valid way to import such packages.
// eslint-disable-next-line @typescript-eslint/no-var-requires
const Razorpay = require("razorpay");

// Initialize Firebase Admin SDK
admin.initializeApp();
const db = admin.firestore();

// Define a type for the data we expect from the Flutter app
interface TicketRequestData {
  paymentId: string;
  eventId: string;
  ticketQuantities: { [key: string]: number };
  totalAmount: number;
}

// Initialize Razorpay SDK using secret keys
const razorpay = new Razorpay({
  key_id: functions.config().razorpay.key_id,
  key_secret: functions.config().razorpay.key_secret,
});

/**
 * An HTTPS Callable Function to verify a Razorpay payment and create a ticket.
 */
export const verifyPaymentAndCreateTicket = functions.https.onCall(
    async (data: TicketRequestData, context) => {
      // 1. Security Checks & Input Validation
      if (!context.auth) {
        throw new functions.https.HttpsError(
            "unauthenticated",
            "You must be logged in to purchase tickets.",
        );
      }

      const {paymentId, eventId, ticketQuantities, totalAmount} = data;
      if (!paymentId || !eventId || !ticketQuantities || !totalAmount) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            "The function must be called with all required arguments.",
        );
      }

      try {
        // 2. Verify the Payment with Razorpay's Servers
        const payment = await razorpay.payments.fetch(paymentId);

        if (payment.status !== "captured") {
          throw new functions.https.HttpsError("aborted", "Payment was not successful.");
        }
        if (payment.amount !== totalAmount * 100) {
          throw new functions.https.HttpsError("aborted", "Payment amount does not match.");
        }
        if (payment.currency !== "INR") {
          throw new functions.https.HttpsError("aborted", "Invalid currency.");
        }

        // 3. Run a Firestore Transaction to Create the Ticket
        const newTicketRef = db.collection("user_tickets").doc();
        const eventRef = db.collection("events").doc(eventId);

        await db.runTransaction(async (transaction) => {
          const eventDoc = await transaction.get(eventRef);
          if (!eventDoc.exists) {
            throw new functions.https.HttpsError("not-found", "Event not found.");
          }
          const eventData = eventDoc.data();
          if (!eventData) {
            throw new functions.https.HttpsError("internal", "Event data is empty.");
          }

          const purchasedTickets: { name: string; price: number; quantity: number }[] = [];

          for (const ticketName in ticketQuantities) {
            const quantityToBuy = ticketQuantities[ticketName];
            if (quantityToBuy > 0) {
              const ticketType = eventData.ticketTypes.find((t: any) => t.name === ticketName);
              if (!ticketType || ticketType.quantity < quantityToBuy) {
                throw new functions.https.HttpsError("resource-exhausted", `Not enough '${ticketName}' tickets available.`);
              }
              ticketType.quantity -= quantityToBuy;
              purchasedTickets.push({
                name: ticketType.name,
                price: ticketType.price,
                quantity: quantityToBuy,
              });
            }
          }

          transaction.update(eventRef, {ticketTypes: eventData.ticketTypes});

          transaction.set(newTicketRef, {
            userId: context.auth?.uid,
            eventId: eventId,
            eventName: eventData.title,
            purchaseDate: admin.firestore.FieldValue.serverTimestamp(),
            paymentId: paymentId,
            tickets: purchasedTickets,
            totalAmount: totalAmount,
          });
        });

        // 4. Return Success Response
        return {success: true, ticketId: newTicketRef.id};
      } catch (error) {
        functions.logger.error("Payment verification failed:", error);
        if (error instanceof functions.https.HttpsError) {
          throw error;
        }
        throw new functions.https.HttpsError("internal", "An unexpected error occurred.");
      }
    },
);