import re

# Test regex pattern
test_string = "This is a test <form><textarea>example content</textarea></form> string."
pattern = r'(?s)(?<=<form><textarea\b[^>]*>)(.*?)(?=</textarea></form>)'
matches = re.findall(pattern, test_string)

print(matches)
