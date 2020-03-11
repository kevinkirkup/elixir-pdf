defmodule Pdf.TextTest do
  use ExUnit.Case, async: true

  alias Pdf.Text

  describe "wrap/2" do
    test "it breaks on a space" do
      font = Pdf.Font.Helvetica
      font_size = 10
      string = "Hello World"
      width = font.text_width("World", font_size)

      assert Text.wrap(font, font_size, string, width) == ["Hello", "World"]
    end

    test "it breaks on a zero-width space" do
      font = Pdf.Font.Helvetica
      font_size = 10
      string = "Hello\u200BWorld"

      width = font.text_width("Hello", font_size)
      assert Text.wrap(font, font_size, string, width) == ["Hello", "World"]
    end

    test "it does not display zero-width space" do
      font = Pdf.Font.Helvetica
      font_size = 10
      string = "Hello\u200BWorld"

      width = font.text_width("Hello World", font_size)
      assert Text.wrap(font, font_size, string, width) == ["HelloWorld"]
    end

    test "it breaks on a tab" do
      font = Pdf.Font.Helvetica
      font_size = 10
      string = "Hello\tWorld"

      width = font.text_width("Hello", font_size)
      assert Text.wrap(font, font_size, string, width) == ["Hello", "World"]
    end

    test "it does not break on a non-breaking space" do
      font = Pdf.Font.Helvetica
      font_size = 10
      string = "Hello\u00A0World"

      width = font.text_width("Hello  ", font_size)
      assert Text.wrap(font, font_size, string, width) == ["Hello\u00A0World"]
    end

    test "it includes words that are longer than the wrapping boundary" do
      font = Pdf.Font.Helvetica
      font_size = 10
      string = "Hello WWWWWorld"
      width = font.text_width("Hello", font_size)

      assert Text.wrap(font, font_size, string, width) == ["Hello", "WWWWWorld"]
    end

    test "It correctly handles the breaking character (drops the appropriate space)" do
      font = Pdf.Font.Helvetica
      font_size = 10
      string = "foo bar baz"
      width = font.text_width("foo bar", font_size)

      assert Text.wrap(font, font_size, string, width) == ["foo bar", "baz"]
    end

    test "It force wraps on a charriage return" do
      font = Pdf.Font.Helvetica
      font_size = 10
      string = "foo\nbar baz"
      width = font.text_width("bar baz", font_size)

      assert Text.wrap(font, font_size, string, width) == ["foo", "bar baz"]
    end

    test "It force wraps on every charriage return" do
      font = Pdf.Font.Helvetica
      font_size = 10
      string = "foo\n\n\nbar baz"
      width = font.text_width("bar baz", font_size)

      assert Text.wrap(font, font_size, string, width) == ["foo", "", "", "bar baz"]
    end

    test "It wraps after a hyphen" do
      font = Pdf.Font.Helvetica
      font_size = 10
      string = "foo bar-baz"
      width = font.text_width("foo bar-b", font_size)

      assert Text.wrap(font, font_size, string, width) == ["foo bar-", "baz"]
    end

    test "It wraps after " do
      font = Pdf.Font.Helvetica
      font_size = 10
      string = "foo bar-baz"
      width = font.text_width("foo bar-b", font_size)

      assert Text.wrap(font, font_size, string, width) == ["foo bar-", "baz"]
    end
  end
end
