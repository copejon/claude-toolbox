# Multi-Persona Analysis Template

This is the blank template to be filled in during prompt synthesis. Each placeholder in brackets must be replaced with domain-specific content derived from the user's use case.

```xml
<multi_persona_analysis>

<context>
Subject: [INSERT YOUR SUBJECT/TOPIC HERE]
Objective: [WHAT YOU WANT TO ACHIEVE]
Constraints: [ANY LIMITATIONS, REQUIREMENTS, OR BOUNDARIES]
</context>

<personas>

<persona id="1">
<role>Stakeholder A: [TITLE/PERSPECTIVE]</role>
<focus>[PRIMARY CONCERNS AND PRIORITIES]</focus>
<mandate>
Analyze the subject through your lens, considering:
- Your core responsibilities and success metrics
- Risks and opportunities specific to your domain
- Trade-offs from your perspective
- Recommendations based on your expertise
</mandate>
</persona>

<persona id="2">
<role>Stakeholder B: [TITLE/PERSPECTIVE]</role>
<focus>[PRIMARY CONCERNS AND PRIORITIES]</focus>
<mandate>
Analyze the subject through your lens, considering:
- Your core responsibilities and success metrics
- Risks and opportunities specific to your domain
- Trade-offs from your perspective
- Recommendations based on your expertise
</mandate>
</persona>

<persona id="3">
<role>Stakeholder C: [TITLE/PERSPECTIVE]</role>
<focus>[PRIMARY CONCERNS AND PRIORITIES]</focus>
<mandate>
Analyze the subject through your lens, considering:
- Your core responsibilities and success metrics
- Risks and opportunities specific to your domain
- Trade-offs from your perspective
- Recommendations based on your expertise
</mandate>
</persona>

</personas>

<interaction_protocol>
1. Each persona presents their analysis independently (150-250 words each)
2. Personas identify points of alignment and tension
3. Personas engage in constructive dialogue to address conflicts
4. All personas contribute to a synthesized recommendation
</interaction_protocol>

<output_format>
For each persona:
- **Position Statement**: Core perspective in 2-3 sentences
- **Detailed Analysis**: Key considerations, concerns, and insights
- **Recommendations**: Specific actionable suggestions

Then provide:
- **Cross-Persona Dialogue**: Where perspectives align/conflict
- **Synthesized Recommendation**: Integrated final guidance balancing all viewpoints
</output_format>

<quality_controls>
- Each persona must maintain authentic voice and priorities
- Avoid artificial consensus - acknowledge genuine tensions
- Ground recommendations in each persona's domain expertise
- Synthesized output should reflect nuanced trade-offs, not compromise to mediocrity
</quality_controls>

</multi_persona_analysis>
```

## Template Rules

- The `<personas>` section scales to 2-4 personas. Remove or add `<persona>` blocks as needed.
- The `<mandate>` for each persona must be customized with domain-specific analysis questions — never leave the generic bullets in place.
- The `<interaction_protocol>` word counts and step count may be adjusted based on use case complexity.
- The `<output_format>` may be modified to match specific deliverable needs.
- The `<quality_controls>` section should gain domain-specific additions while keeping the four core controls.
