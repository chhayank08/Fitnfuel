import re

# Test data from the dataset
test_data = '''c(""https://img.sndimg.com/food/image/upload/w_555,h_416,c_fit,fl_progressive,q_95/v1/img/recipes/38/YUeirxMLQaeE1h3v3qnM_229%20berry%20blue%20frzn%20dess.jpg"", ""https://img.sndimg.com/food/image/upload/w_555,h_416,c_fit,fl_progressive,q_95/v1/img/recipes/38/AFPDDHATWzQ0b1CDpDAT_255%20berry%20blue%20frzn%20dess.jpg"")'''

def clean_image_url(url):
    if not isinstance(url, str) or not url:
        return ''
    
    # Extract URLs from c(""url1"", ""url2"") format - get first URL
    url_pattern = re.compile(r'""(https://img\.sndimg\.com/[^"]+)""')
    match = url_pattern.search(url)
    
    if match:
        return match.group(1)
    
    # Fallback for single quotes
    url_pattern2 = re.compile(r'"(https://img\.sndimg\.com/[^"]+)"')
    match2 = url_pattern2.search(url)
    
    if match2:
        return match2.group(1)
    
    return ''

# Test the function
result = clean_image_url(test_data)
print(f"Extracted URL: {result}")

# Test with single quote format
test_data2 = '"https://img.sndimg.com/food/image/upload/w_555,h_416,c_fit,fl_progressive,q_95/v1/img/recipes/42/picVEMxk8.jpg"'
result2 = clean_image_url(test_data2)
print(f"Extracted URL 2: {result2}")