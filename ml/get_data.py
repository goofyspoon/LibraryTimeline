from selenium import webdriver
import pandas as pd

options = webdriver.ChromeOptions()
options.add_experimental_option('excludeSwitches', ['enable-logging'])
driver = webdriver.Chrome("/usr/lib/chromium-browser/chromedriver", options=options)
driver.get('https://app.thestorygraph.com/browse')

def get_page_number(title, author):
    driver.get(f'https://app.thestorygraph.com/browse?search_term={title}')
    xpath = "//div[contains(@class, 'book-title-author-and-series')]/following-sibling::p" #/text()
    pages = driver.find_elements("xpath", xpath)
    # search_box.clear()
    try:   
        return pages[0].text
    except:
        return "0 pages"


def main():
    data = pd.read_csv("../data/cleaned_data.csv")

    to_return = data.copy()

    for index, book in data.iterrows():
        to_return.at[index, 'number_of_pages_author'] = get_page_number(book['title']).split(" ")[0]
    to_return.to_csv("../data/scraped_data.csv")


if __name__ == "__main__":
    main()
