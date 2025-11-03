# Contributing to EEG Sleep Stage Analysis

Thank you for your interest in contributing to this project! This document provides guidelines for contributing.

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a new branch for your feature or bugfix
4. Make your changes
5. Test your changes
6. Submit a pull request

## Code Style Guidelines

### MATLAB Code
- Use descriptive variable names
- Add comprehensive header comments to all functions
- Follow the existing code structure and formatting
- Include input/output documentation with types
- Add usage examples in function headers

### Function Header Template
```matlab
function [output1, output2] = function_name(input1, input2)
% FUNCTION_NAME Brief description of what the function does
%
% More detailed description if needed. Explain the purpose and method.
%
% Inputs:
%   input1 - Description of first input with type
%   input2 - Description of second input with type
%
% Outputs:
%   output1 - Description of first output
%   output2 - Description of second output
%
% Example:
%   [out1, out2] = function_name(in1, in2);
%
% See also: RELATED_FUNCTION1, RELATED_FUNCTION2

    % Implementation here
end
```

## Documentation

- Update README.md if you add new features
- Update FUNCTIONS.md if you add or modify functions
- Update CHANGELOG.md with your changes
- Ensure DATA_FORMAT.md is current if data requirements change

## Testing

Before submitting a PR:

1. Test with sample data
2. Verify all figures are generated correctly
3. Check that the pipeline runs end-to-end without errors
4. Verify your changes don't break existing functionality

## Commit Messages

Use clear, descriptive commit messages:
- Start with a verb in present tense (Add, Fix, Update, Remove)
- Keep the first line under 72 characters
- Add detailed description if needed

Good examples:
```
Add entropy calculation for sleep stage analysis
Fix bug in epoch segmentation for short signals
Update README with installation instructions
```

## Pull Request Process

1. Update documentation to reflect your changes
2. Ensure your code follows the style guidelines
3. Test your changes thoroughly
4. Add yourself to the contributors list if desired
5. Submit the PR with a clear description of changes

## Areas for Contribution

Potential areas where contributions are welcome:

### Features
- Additional entropy metrics
- Machine learning classifiers
- Support for multi-channel EEG
- Real-time analysis capabilities
- Export to standard sleep analysis formats

### Documentation
- More usage examples
- Video tutorials
- Translated documentation
- Additional dataset examples

### Code Quality
- Unit tests
- Performance optimization
- Error handling improvements
- Code refactoring

### Data Support
- Additional data format converters
- Integration with public databases
- Sample datasets (with proper licensing)

## Questions?

If you have questions about contributing, please:
1. Check existing issues and pull requests
2. Review the documentation
3. Open a new issue with your question

## Code of Conduct

- Be respectful and constructive
- Welcome newcomers
- Focus on the best outcome for the project
- Give credit where it's due

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

Thank you for contributing to EEG Sleep Stage Analysis!
