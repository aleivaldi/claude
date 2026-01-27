#!/usr/bin/env python3
"""
Semantic Test Validator
========================
Valida che i test contract/integration siano semanticamente validi,
non solo che esistano (count > 0).

Controlla:
1. NO trivial assertions (expect(true).toBe(true))
2. Contract coverage (test references API schemas/types)
3. HTTP method coverage (for API blocks)
4. Response schema validation
5. Error case coverage (4xx tests)

Usage:
    python semantic-test-validator.py <test-file-path> [--format json|text]

Exit codes:
    0 = All checks passed
    1 = Critical issues found
    2 = Warnings found (can proceed)
"""

import sys
import re
import json
from pathlib import Path
from typing import List, Dict, Optional
from enum import Enum


class Severity(str, Enum):
    CRITICAL = "CRITICAL"
    WARNING = "WARNING"
    INFO = "INFO"


class Issue:
    def __init__(self, severity: Severity, check: str, message: str, line: Optional[int] = None):
        self.severity = severity
        self.check = check
        self.message = message
        self.line = line

    def to_dict(self):
        return {
            "severity": self.severity.value,
            "check": self.check,
            "message": self.message,
            "line": self.line
        }


class SemanticTestValidator:
    """Validates semantic quality of contract/integration tests."""

    def __init__(self, test_file_path: str):
        self.file_path = Path(test_file_path)
        self.content = self.file_path.read_text()
        self.lines = self.content.split('\n')
        self.issues: List[Issue] = []

    def validate(self) -> List[Issue]:
        """Run all validation checks."""
        self.check_trivial_assertions()
        self.check_contract_references()
        self.check_http_method_coverage()
        self.check_response_validation()
        self.check_error_cases()
        return self.issues

    # ========================================================================
    # Check 1: Trivial Assertions
    # ========================================================================

    def check_trivial_assertions(self):
        """Detect trivial assertions that always pass."""
        trivial_patterns = [
            r'expect\(true\)\.toBe\(true\)',
            r'expect\(false\)\.toBe\(false\)',
            r'expect\(1\)\.toBe\(1\)',
            r'assert True',
            r'assert 1 == 1',
            r'self\.assertTrue\(True\)',
            r'expect\(["\'].*["\']\)\.toBe\(["\'].*["\']\)',  # Same string comparison
        ]

        for i, line in enumerate(self.lines):
            for pattern in trivial_patterns:
                if re.search(pattern, line):
                    self.issues.append(Issue(
                        severity=Severity.CRITICAL,
                        check="trivial_assertion",
                        message=f"Trivial assertion found: {line.strip()}",
                        line=i + 1
                    ))

    # ========================================================================
    # Check 2: Contract References
    # ========================================================================

    def check_contract_references(self):
        """Check if tests reference API schemas, types, or contracts."""
        # Cerca import di schemas/types/contracts
        schema_import_patterns = [
            r'import.*Schema.*from',
            r'import.*Type.*from',
            r'import.*Contract.*from',
            r'from.*schemas.*import',
            r'from.*types.*import',
            r'from.*contracts.*import',
        ]

        has_schema_import = any(
            re.search(pattern, self.content, re.IGNORECASE)
            for pattern in schema_import_patterns
        )

        # Cerca usage di validazione schema
        schema_usage_patterns = [
            r'\.validate\(',
            r'\.parse\(',
            r'z\.',  # Zod
            r'Joi\.',  # Joi
            r'ajv\.',  # AJV
            r'validateSchema\(',
        ]

        has_schema_usage = any(
            re.search(pattern, self.content)
            for pattern in schema_usage_patterns
        )

        if not has_schema_import and not has_schema_usage:
            self.issues.append(Issue(
                severity=Severity.CRITICAL,
                check="contract_reference",
                message="Test does not reference any schemas, types, or contracts. Contract tests should validate against defined contracts."
            ))

    # ========================================================================
    # Check 3: HTTP Method Coverage (for API tests)
    # ========================================================================

    def check_http_method_coverage(self):
        """For API tests, check coverage of HTTP methods."""
        # Detect se questo è un test API
        api_test_indicators = [
            r'describe.*api',
            r'describe.*endpoint',
            r'test.*GET|POST|PUT|DELETE|PATCH',
            r'request\(',
            r'axios\.',
            r'fetch\(',
        ]

        is_api_test = any(
            re.search(pattern, self.content, re.IGNORECASE)
            for pattern in api_test_indicators
        )

        if not is_api_test:
            return  # Skip se non è test API

        # Check coverage metodi HTTP
        http_methods = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH']
        methods_tested = set()

        for method in http_methods:
            # Cerca pattern tipo: .get(, .post(, test('GET ...')
            patterns = [
                rf'\.{method.lower()}\(',
                rf'method:\s*["\']({method})["\']',
                rf'test\(["\'].*{method}',
            ]
            if any(re.search(p, self.content, re.IGNORECASE) for p in patterns):
                methods_tested.add(method)

        # Estrai metodi dichiarati nel file (es: in describe o commenti)
        declared_methods = set()
        for match in re.finditer(r'(GET|POST|PUT|DELETE|PATCH)', self.content):
            declared_methods.add(match.group(1))

        # Se metodi sono dichiarati ma non testati → warning
        untested_methods = declared_methods - methods_tested
        if untested_methods:
            self.issues.append(Issue(
                severity=Severity.WARNING,
                check="http_method_coverage",
                message=f"HTTP methods declared but not tested: {', '.join(untested_methods)}"
            ))

    # ========================================================================
    # Check 4: Response Schema Validation
    # ========================================================================

    def check_response_validation(self):
        """Check if response schemas are validated."""
        # Cerca pattern di validazione response
        validation_patterns = [
            r'expect\(response\.body\)\.toMatchSchema',
            r'expect\(response\.data\)\.toMatchObject',
            r'\.validate\(response',
            r'schema\.parse\(response',
            r'expect\(response\)\.toHaveProperty',
        ]

        has_response_validation = any(
            re.search(pattern, self.content)
            for pattern in validation_patterns
        )

        # Conta assertions su response
        response_assertions = len(re.findall(r'expect\(response', self.content))

        if response_assertions == 0:
            self.issues.append(Issue(
                severity=Severity.WARNING,
                check="response_validation",
                message="No response validation found. Contract tests should validate response structure."
            ))
        elif not has_response_validation and response_assertions > 0:
            self.issues.append(Issue(
                severity=Severity.INFO,
                check="response_validation",
                message="Response assertions found but no explicit schema validation. Consider using schema validators (Zod, Joi, etc.)"
            ))

    # ========================================================================
    # Check 5: Error Case Coverage
    # ========================================================================

    def check_error_cases(self):
        """Check if error cases (4xx, 5xx) are tested."""
        error_test_patterns = [
            r'(400|401|403|404|422|500|502|503)',  # Status codes
            r'test.*error',
            r'test.*fail',
            r'test.*invalid',
            r'expect.*toThrow',
            r'expect.*status.*4\d{2}',
        ]

        has_error_tests = any(
            re.search(pattern, self.content, re.IGNORECASE)
            for pattern in error_test_patterns
        )

        # Conta success test (2xx)
        success_tests = len(re.findall(r'200|201|204', self.content))

        if success_tests > 0 and not has_error_tests:
            self.issues.append(Issue(
                severity=Severity.WARNING,
                check="error_coverage",
                message="Only success cases (2xx) tested. Consider adding error case tests (4xx)."
            ))


# ============================================================================
# CLI
# ============================================================================

def main():
    if len(sys.argv) < 2:
        print("Usage: semantic-test-validator.py <test-file-path> [--format json|text]", file=sys.stderr)
        sys.exit(2)

    test_file = sys.argv[1]
    output_format = "text"

    if "--format" in sys.argv:
        idx = sys.argv.index("--format")
        if idx + 1 < len(sys.argv):
            output_format = sys.argv[idx + 1]

    if not Path(test_file).exists():
        print(f"ERROR: Test file not found: {test_file}", file=sys.stderr)
        sys.exit(2)

    # Run validation
    validator = SemanticTestValidator(test_file)
    issues = validator.validate()

    # Output
    if output_format == "json":
        result = {
            "file": test_file,
            "issues": [issue.to_dict() for issue in issues],
            "critical_count": sum(1 for i in issues if i.severity == Severity.CRITICAL),
            "warning_count": sum(1 for i in issues if i.severity == Severity.WARNING),
        }
        print(json.dumps(result, indent=2))
    else:
        # Text format
        if not issues:
            print(f"✅ {test_file}: All semantic checks passed")
            sys.exit(0)

        print(f"Semantic Validation Results: {test_file}")
        print("=" * 60)

        critical = [i for i in issues if i.severity == Severity.CRITICAL]
        warnings = [i for i in issues if i.severity == Severity.WARNING]
        info = [i for i in issues if i.severity == Severity.INFO]

        if critical:
            print(f"\n❌ CRITICAL ISSUES ({len(critical)}):")
            for issue in critical:
                line_info = f" (line {issue.line})" if issue.line else ""
                print(f"  - [{issue.check}]{line_info}: {issue.message}")

        if warnings:
            print(f"\n⚠️  WARNINGS ({len(warnings)}):")
            for issue in warnings:
                line_info = f" (line {issue.line})" if issue.line else ""
                print(f"  - [{issue.check}]{line_info}: {issue.message}")

        if info:
            print(f"\nℹ️  INFO ({len(info)}):")
            for issue in info:
                line_info = f" (line {issue.line})" if issue.line else ""
                print(f"  - [{issue.check}]{line_info}: {issue.message}")

    # Exit code
    critical_count = sum(1 for i in issues if i.severity == Severity.CRITICAL)
    warning_count = sum(1 for i in issues if i.severity == Severity.WARNING)

    if critical_count > 0:
        sys.exit(1)
    elif warning_count > 0:
        sys.exit(2)
    else:
        sys.exit(0)


if __name__ == "__main__":
    main()
