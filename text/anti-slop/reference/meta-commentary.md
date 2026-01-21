# Removing Unnecessary Meta-Commentary

Meta-commentary is "writing about the writing." It consists of stage directions that tell the reader what you are doing rather than just doing it.

## The "AI Preamble"

AI-generated text almost always starts with a preamble that explains what it is about to say.

| Meta-Commentary | Why it's slop | Better Approach |
|-----------------|---------------|-----------------|
| "In this document, we will..." | Obvious from title/context | Delete and start the point |
| "Let's take a closer look at..." | Filler "stage direction" | Use a descriptive header |
| "It's important to note that..." | Padding | Just state the important point |
| "Now that we've covered X, let's..." | Hand-holding | Use a new header or transition |
| "As we'll explore in the next section..." | Self-reference | Let the document flow naturally |

## Common Self-Referential Patterns

### Stage Directions
- **"I will now discuss..."** → Just start discussing.
- **"This section aims to..."** → Let the header define the aim.
- **"Having discussed X, we move to Y..."** → Redundant transition.

### "Crucial" Padding
AI loves telling you that things are important instead of showing why.
- **"It is worth noting that..."** → Delete.
- **"It should be emphasized that..."** → Delete.
- **"One must keep in mind that..."** → Delete.

## Leading with the Point

Meta-commentary often "buries the lead." Move the actual information to the front.

- **Bad**: "In the following paragraph, I will explain the installation process. It's important to remember that before you start, you need to check your Python version."
- **Good**: "Check your Python version before installation."

## When Meta-Commentary is Acceptable

In very long documents (books, whitepapers, long tutorials), brief roadmaps can be helpful for navigation. However, for READMEs, blog posts, and most technical docs, they are slop.

**Acceptable Roadmap**:
"This guide is structured into three parts: installation, basic usage, and advanced configuration."

**Slop Roadmap**:
"In the first part of this comprehensive guide, we will delve into the complexities of the installation process. Then, we'll navigate through the basic usage patterns before ultimately exploring advanced configuration options."

## Workflow: Cutting the Meta

1. **Delete the first sentence**: In AI-generated sections, the first sentence is often 100% meta-commentary.
2. **Scan for "In this..."**: "In this section", "In this document", "In this guide".
3. **Scan for "It is..."**: "It is important", "It is worth noting", "It is crucial".
4. **Headers as Roadmaps**: Use clear, descriptive headers (`## Installation`) instead of sentences describing the section (`In this section we will cover installation`).
5. **The "Direct Test"**: If you remove the meta-commentary, does the reader lose any *information*? If not, delete it.
