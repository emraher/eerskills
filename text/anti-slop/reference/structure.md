# Document Structure and Organization

Generic AI text often follows a predictable, "five-paragraph essay" or "cookie-cutter template" structure. Professional technical writing organizes information based on user needs and logical flow.

## Avoiding Template Syndrome

AI often forces content into this rigid template regardless of the topic:
1. Introduction (with preamble)
2. Features/Benefits (exactly three)
3. "How it Works" (vague)
4. Use Cases
5. Conclusion (summary of what was just said)

### Better Alternatives

Organize based on the **purpose** of the document:

- **Tutorial**: Task-based. Setup → Step 1 → Step 2 → Step 3 → Verification.
- **Reference**: Object-based. Function name → Arguments → Return → Example.
- **Guide**: Problem-based. Concept → Solution A → Solution B → Trade-offs.
- **README**: Summary → Installation → Quick Start → Documentation links.

## Effective Hierarchy

### Use Descriptive Headers
Headers should tell the reader exactly what to expect.

- **Bad**: Introduction, Details, Summary, Conclusion.
- **Good**: Getting Started, API Reference, Performance Benchmarks, Troubleshooting.

### Lead with the Important Info
Follow the "Inverted Pyramid" style: put the most critical information at the top.

1. **The Hook/Summary**: What is this? Why does it matter?
2. **The Action**: How do I use it right now?
3. **The Details**: How does it work? Why was it built this way?
4. **The Edge Cases**: Troubleshooting and advanced usage.

## Paragraph Construction

- **One Idea per Paragraph**: Keep paragraphs short and focused.
- **Topic Sentences**: Start each paragraph with the main point.
- **Variable Length**: Mix short and medium sentences to maintain interest.
- **Avoid "The Wall of Text"**: Use lists, code blocks, and tables to break up long sections.

## List Best Practices

Lists are excellent for technical clarity, but AI often overuses them for fluff.

- **Bullet Points**: For items with no particular order.
- **Numbered Lists**: For sequences of steps.
- **Definition Lists**: For terms and their descriptions.

**Slop List**:
- **Leverage**: Use our power.
- **Empower**: Feel the potential.
- **Seamless**: Enjoy the flow.

**Effective List**:
- **Auth Service**: Handles OAuth2 and JWT validation.
- **Rate Limiter**: Enforces 100 req/min threshold.
- **Storage**: Uses S3 for persistent binary data.

## Using Code and Examples

Code should be a first-class citizen in technical documents.

1. **Lead with code**: Show an example before explaining it.
2. **Keep examples short**: Focus on the specific feature being discussed.
3. **Show, don't tell**: A code block is often better than two paragraphs of prose.
4. **Explain code inline**: Use comments or brief explanations immediately following the block.

## Workflow: Structuring for Humans

1. **Identify the user's goal**: What is the *one thing* they need to do after reading this?
2. **Map the path**: List the minimum steps needed to reach that goal.
3. **Write headers first**: Build the skeleton before adding prose.
4. **Prune the "Intro/Outro"**: Most technical docs don't need a formal introduction or conclusion.
5. **Add Proof**: Use tables, benchmarks, or specific data to back up claims.
