require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new(:title => "My book title", 
			  :description => "yyy",
			  :image_url => 'zzz.jpg')
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
	    product.errors[:price].join('; ')
    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
	    product.errors[:price].join('; ')
    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(:title => "My book title",
		:description => 'yyy',
		:price => 1,
		:image_url => image_url)
  end

  test "image_url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    ok.each do |name|
	    assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
		assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "product is invalid if title is not unique" do
    product = Product.new(:title => products(:ruby).title,
			  :price => 2.2,
			  :description => "desc",
			  :image_url => 'me.png')
    assert !product.save
    assert_equal I18n.translate('activerecord.errors.messages.taken'), product.errors[:title].join('; ')
    			

  end
end
