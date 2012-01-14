require 'helper'

class TestMabMixin < MiniTest::Unit::TestCase
  def setup
    super
    @obj = Object.new
  end

  def test_tag
    @obj.extend Mab::Mixin

    assert_equal '<br>', @obj.mab {
      tag! :br
    }

    assert_equal '<p>Hello</p>', @obj.mab {
      tag! :p, 'Hello'
    }

    assert_equal '<p class="intro">Hello</p>', @obj.mab {
      tag! :p, 'Hello', :class => "intro"
    }

    assert_equal '<p><br></p>', @obj.mab {
      tag! :p do
        tag! :br
      end
    }

    assert_equal '<br class="intro">', @obj.mab {
      tag! :br, :class => 'intro'
    }

    assert_equal '<br>', @obj.mab {
      tag! :br, :class => nil
    }
  end

  def test_escaping
    @obj.extend Mab::Mixin

    assert_equal '<p>&amp;</p>', @obj.mab {
      tag! :p, '&'
    }

    assert_equal '<p>&</p>', @obj.mab {
      tag! :p do '&' end
    }

    assert_equal '&amp;', @obj.mab { text '&' }
  end

  def test_chaining
    @obj.extend Mab::Mixin

    assert_equal '<p class="intro" id="first">Hello</p>', @obj.mab {
      tag!(:p).intro.first!('Hello')
    }

    assert_raises(Mab::Mixin::Error) do
      @obj.mab do
        tag!(:p).intro('Hello').first!('Hello')
      end
    end

    assert_raises(Mab::Mixin::Error) do
      @obj.mab do
        tag!(:p).intro(:class => 'bar').first!('Hello')
      end
    end
  end

  def test_xml
    @obj.extend Mab::Mixin
    @obj.mab_options[:xml] = true

    assert_equal '<br /><br></br><br>hello</br>', @obj.mab {
      tag! :br
      tag! :br, ''
      tag! :br, 'hello'
    }
  end

  def test_html5
    @obj.extend Mab::Mixin::HTML5
    assert_equal '<!DOCTYPE html><html><body><p></p><br></body></html>', @obj.mab {
      doctype!
      html do
        body do
          p
          br
        end
      end
    }

    assert_raises Mab::Mixin::Error do
      @obj.mab { br { } }
    end

    assert_raises Mab::Mixin::Error do
      @obj.mab { br "hello" }
    end
  end

  def test_xhtml5
    @obj.extend Mab::Mixin::XHTML5
    assert_equal '<!DOCTYPE html><html><body><p></p><br /></body></html>', @obj.mab {
      doctype!
      html do
        body do
          p
          br
        end
      end
    }

    assert_raises Mab::Mixin::Error do
      @obj.mab { br { } }
    end

    assert_raises Mab::Mixin::Error do
      @obj.mab { br "hello" }
    end
  end

  def test_core_xml
    @obj.extend Mab::Mixin::XML
    assert_equal '<br />', @obj.mab {
      tag! :br
    }
  end
end
