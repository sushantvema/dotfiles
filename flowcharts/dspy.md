dspy.md
	DSPY Prompt Engineering Framework
		References
		Process
			1. Define your task
				Expected input/output behavior
					Inline DSPy Signatures
					Class-based DSPy Signatures
			2. Define your pipeline
				Modules
					Abstract commonly used prompting techniques + handle all DSPy signatures
					Modules have learnable parameters (prompt + LM weights optionally)
					Modules can be composed into bigger modules (programs)
					List of provided Modules
						dspy.Predict
						dspy.ChainOfThought
			3. Explore a few examples
			4. Define your data
			5. Define your metric
			6. Collect preliminary zero-shot evaluations
			7. Compile with a DSPy optimizer
			8. Iterate
		Structure

