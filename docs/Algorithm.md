# Algorithms and Logic

This document details the core algorithms and logical flows that power the AI-Powered Mental Health Companion, specifically focusing on the AI interactions and clinical assessments.

## Cognitive Behavioral Therapy (CBT) Processing Logic

The chatbot does not operate as a general-purpose AI; it is strictly constrained through system prompts to employ CBT techniques. 

### Processing Steps:
1. **Input Reception**: The user submits a text string detailing their current state.
2. **Context Aggregation**: The system concatenates the last N messages to maintain conversation context.
3. **Prompt Engineering**: The input is wrapped in a strict system prompt directing the Gemini API to:
   - Identify cognitive distortions (e.g., catastrophizing, black-and-white thinking).
   - Validate the user's feelings without confirming the distorted logic.
   - Propose a reframing exercise or ask a Socratic question to guide the user to a healthier perspective.
4. **Safety Filter**: If the input matches a predefined array of high-risk keywords (e.g., "suicide", "harm", "end it"), the AI response is bypassed entirely, and the application immediately triggers the Crisis Routing Protocol.

## Diagnostic Assessment Scoring (PHQ-9 & GAD-7)

The application implements standardized clinical questionnaires. The scoring algorithm operates in real-time.

### Calculation Logic:
1. **Response Values**: Each question is answered on a Likert scale mapped to integer values:
   - Not at all = 0
   - Several days = 1
   - More than half the days = 2
   - Nearly every day = 3
2. **Summation**: Total Score = Sum of all response values.
3. **Severity Categorization**:
   - 0-4: Minimal
   - 5-9: Mild
   - 10-14: Moderate
   - 15-19: Moderately Severe
   - 20-27: Severe
4. **Actionable Output**: Based on the severity threshold, the system automatically suggests relevant app modules (e.g., routing to the Medical Directory for Severe scores).
