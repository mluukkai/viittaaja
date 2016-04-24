require 'rails_helper'

describe 'References page' do

  it 'lists all current references' do
    Reference.create reference_type:'book', year:1990, author:"Teppo", title:"Matti", publisher:"Suomiboyz"
    Reference.create reference_type:'article', year:1980, author:"Barack Öbämå", title:"USA", journal:"dsaasd", volume:1
    Reference.create reference_type:'inproceeding', year:1930, author:"asd", title:"jou", booktitle:"herp"

    visit references_path

    @book_reference = find_by_id('books').find('tbody').find('tr:nth-child(1)')
    @article_reference = find_by_id('articles').find('tbody').find('tr:nth-child(1)')
    @inproceeding_reference = find_by_id('inproceedings').find('tbody').find('tr:nth-child(1)')

    expect(@book_reference.text).to eq "1990 Suomiboyz Teppo Matti EditDestroy"
    expect(@article_reference.text).to eq "1980 dsaasd Barack Öbämå USA 1 EditDestroy"
    expect(@inproceeding_reference.text).to eq "1930 herp asd jou EditDestroy"
  end

  it 'when a new book is added, shows it on the page' do
    User.create username:"asd"
    Reference.create reference_type:'book', year:1990, author:"Teppo", title:"Matti", publisher:"Suomiboyz"
    Reference.create reference_type:'book', year:1990, author:"Barack Öbämå", title:"USA", publisher:"asd"

    visit references_path

    expect(page).to have_xpath(".//tr", count: 5)
    expect(page).not_to have_content("2000 Kebab on hyvää")

    click_link "Add reference"

    fill_in 'reference_year', with: '2000'
    fill_in 'reference_publisher', with: 'Kebab'
    fill_in 'reference_author', with: 'on'
    fill_in 'reference_title', with: 'hyvää'
    click_button "Create Reference"
    expect(page).to have_xpath(".//tr", count: 6)

    expect(page).to have_content("2000 Kebab on hyvää")
  end

  it 'when bibtex-button is pressed, opens up a page showing references in bibtex format' do
    ref = Reference.create year:1990, author:"Barack Öbämå", title:"USA", publisher:"asd", reference_type:"book"
    ref.update_attribute(:citation_key, ref.generate_citation_key)

    visit references_path

    click_link "Bibtex"
    @bibtex_textbox = find('textarea')

    expect(page).to have_content "References in BibTex-format"
    expect(@bibtex_textbox.text).to have_content "@Book{ba1990,
                                  year = {1990},
                                  publisher = {asd},
                                  author = {Barack \\\"{O}b\\\"{a}m\\aa},
                                  title = {USA},
                                  }"
  end

  it 'new article is added' do
    visit references_path

    expect(page).to have_xpath(".//tr", count: 3)

    click_link "Add reference"

    select "Article", from: "reference_reference_type"

    fill_in 'reference_year', with: '1995'
    fill_in 'reference_author', with: 'teppo'
    fill_in 'reference_title', with: 'titteli'
    fill_in 'reference_journal', with: 'science'
    fill_in 'reference_volume', with: '14'

    click_button "Create Reference"
    expect(page).to have_xpath(".//tr", count: 4)

    expect(page).to have_content("science")

    @article_reference = find_by_id('articles').find('tbody').find('tr:nth-child(1)')

    expect(@article_reference.text).to eq "te1995 1995 science teppo titteli 14 EditDestroy"
  end

  it 'article is not added with insufficient fields' do
    visit references_path

    expect(page).to have_xpath(".//tr", count: 3)

    click_link "Add reference"

    select "Article", from: "reference_reference_type"

    fill_in 'reference_year', with: '1995'
    fill_in 'reference_author', with: 'teppo'
    fill_in 'reference_title', with: 'titteli'
    fill_in 'reference_journal', with: 'science'

    click_button "Create Reference"

    expect(page).to have_content("can't be blank")

    visit references_path
    
    expect(page).to have_xpath(".//tr", count: 3)
    expect(page).not_to have_content("science")
  end

  it 'new inproceedings is added' do
    visit references_path

    expect(page).to have_xpath(".//tr", count: 3)

    click_link "Add reference"

    select "Inproceeding", from: "reference_reference_type"

    fill_in 'reference_year', with: '1991'
    fill_in 'reference_author', with: 'world'
    fill_in 'reference_title', with: 'blue'
    fill_in 'reference_booktitle', with: 'nature'

    click_button "Create Reference"
    expect(page).to have_xpath(".//tr", count: 4)

    @inproceedings_reference = find_by_id('inproceedings').find('tbody').find('tr:nth-child(1)')

    expect(@inproceedings_reference.text).to eq "wo1991 1991 nature world blue EditDestroy"
  end

  it 'inproceedings is not added with insufficient fields' do
    visit references_path

    expect(page).to have_xpath(".//tr", count: 3)

    click_link "Add reference"

    select "Article", from: "reference_reference_type"


    fill_in 'reference_year', with: '2066'
    fill_in 'reference_author', with: 'the future'
    fill_in 'reference_booktitle', with: 'in the year 2066'

    click_button "Create Reference"

    expect(page).to have_content("can't be blank")

    visit references_path
    
    expect(page).to have_xpath(".//tr", count: 3)
    expect(page).not_to have_content("the future")
  end


  it 'editing makes permanent changes' do

    Reference.create reference_type:'article', year:1980, author:"Barack Öbämå", title:"USA", journal:"dsaasd", volume:1

    visit references_path

    @article_reference = find_by_id('articles').find('tbody').find('tr:nth-child(1)')
    expect(page).to have_xpath(".//tr", count: 4)

    click_link "Edit"

    fill_in 'reference_year', with: '1611'
    click_button "Update Reference"

    expect(page).to have_xpath(".//tr", count: 4)
    expect(page).to have_content("Reference was successfully updated.")

    @article_reference = find_by_id('articles').find('tbody').find('tr:nth-child(1)')
    expect(@article_reference.text).to eq "1611 dsaasd Barack Öbämå USA 1 EditDestroy"
  end


  it 'editing to remove required fields gives an error' do

    Reference.create reference_type:'article', year:1980, author:"Barack Öbämå", title:"USA", journal:"dsaasd", volume:1

    visit references_path

    @article_reference = find_by_id('articles').find('tbody').find('tr:nth-child(1)')
    expect(page).to have_xpath(".//tr", count: 4)

    click_link "Edit"

    fill_in 'reference_year', with: ''
    click_button "Update Reference"

    expect(page).not_to have_content("Reference was successfully updated.")

    expect(page).to have_content("can't be blank")
  end

  it 'deleting a reference removes it permanently', js: true do
    WebMock.disable_net_connect!(allow_localhost:true)

    visit references_path

    click_link "Add reference"

    select "Article", from: "reference_reference_type"

    fill_in 'reference_year', with: '1995'
    fill_in 'reference_author', with: 'teppo'
    fill_in 'reference_title', with: 'titteli'
    fill_in 'reference_journal', with: 'science'
    fill_in 'reference_volume', with: '14'

    click_button "Create Reference"

    @article_reference = find_by_id('articles').find('tbody').find('tr:nth-child(1)')
    expect(page).to have_xpath(".//tr", count: 4)

    click_link "Destroy"

    page.driver.browser.switch_to.alert.accept

    expect(page).not_to have_content("USA")
    expect(page).to have_xpath(".//tr", count: 3)
    expect(page).to have_content("Reference was successfully destroyed.")
  end
end


