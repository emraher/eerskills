# Layout and Structural Antipatterns

Template-driven design forces content into rigid containers. Authentic design starts with content and builds the structure to support it.

## The "AI Landing Page" Formula

AI-generated designs almost always follow this exact sequence:
1. Hero (center-aligned)
2. Logos (Social Proof)
3. Three-column features
4. Big stat numbers
5. Testimonial (centered)
6. Pricing cards
7. "Get Started" CTA

### Why it's Slop
It assumes every product has the same story to tell. It results in "the same landing page as everyone else."

### Better Approach: Story-Driven Layout
Organize the page based on the **user's journey**:
- What is the problem?
- How does the product solve it?
- What is the proof?
- How do I try it?

## Forbidden Layout Patterns

### 1. The Universal 3-Column Feature Grid
- **Pattern**: Exactly three cards with a generic icon, a bold title, and two lines of text.
- **Problem**: It's a lazy default. Not every feature has the same importance or needs the same amount of space.
- **Better**: Vary the layout. Use a 2x2 grid, an alternating "Z-pattern" (image/text, text/image), or a single highlighted feature.

### 2. Cards within Cards
- **Pattern**: Excessive nesting of containers.
- **Problem**: Visual noise and lost screen space.
- **Better**: Use whitespace and subtle background shifts to define areas instead of borders on everything.

### 3. Center-Aligned Paragraphs
- **Pattern**: Long blocks of text (3+ lines) centered in the page.
- **Problem**: Hard for the human eye to find the start of the next line; reduces readability.
- **Better**: Left-align any text longer than a headline.

### 4. The "Big Stat" Section without Context
- **Pattern**: "10,000 Users" "99.9% Uptime" in huge font.
- **Problem**: Lacks credibility if it's not backed by specific details or real-time data.
- **Better**: Show the *impact* of the stat (e.g., "10,000 developers use our API to process 1M requests daily").

## Purposeful Spacing

AI often uses identical spacing (e.g., 64px) between every section, creating a "rhythm of monotony."

- **Use Proximal Grouping**: Put related things closer together (e.g., headline and subheadline) and unrelated things further apart (e.g., features and testimonials).
- **Vary Section Height**: Hero sections should feel "grand," while utility sections (like a logo wall) can be more compact.

## Mobile Layout Slop

- **Generic Bottom Nav**: Exactly 5 icons, often without labels.
- **Hamburger Everything**: Hiding essential navigation on desktop-sized screens.
- **Infinite Scroll without Purpose**: Good for feeds, bad for finding specific information.

## Workflow: Structuring Authentically

1. **Map the Content**: List all the information you *actually* have before opening a design tool.
2. **Prioritize**: Identify the most important piece of information. Give it the most visual weight and best position.
3. **Break the Grid**: If you have 4 features, don't use a 3-column grid and leave one dangling. Use a 2x2 or a list.
4. **Content-First Cards**: Design the card around the longest piece of text you have, not the shortest.
5. **The "Scan Test"**: If you blur your eyes, can you still see the hierarchy and the most important action?
