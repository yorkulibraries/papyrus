# frozen_string_literal: true

require 'test_helper'

class TermsControllerTest < ActionDispatch::IntegrationTest
  context 'as admin' do
    setup do
      @admin_user = create(:user)
      log_user_in(@admin_user)
    end

    should 'be able to create term' do
      assert_difference 'Term.count', 1 do
        attrs = attributes_for(:term)
        post terms_path, params: { term: attrs }
      end

      assert_redirected_to term_path(assigns(:term))
    end

    should 'be able to edit' do
      term = create(:term)
      term.name = 'woot'

      patch term_path(term),
            params: { term: { name: term.name, start_date: term.start_date, end_date: term.end_date } }
      assert_redirected_to term_path(term)
      t = Term.find(term.id)
      assert_equal 'woot', t.name
    end

    should 'be able to destroy' do
      term = create(:term)
      assert_difference 'Term.count', -1 do
        delete term_path(term)
      end
    end

    should 'show term and list all courses alphabetically' do
      term = create(:term)
      create(:course, title: 'a', term:)
      create(:course, title: 'x', term:)

      get term_path(term)
      term = assigns(:term)
      assert term
      assert_equal term.courses.size, 2
      assert_equal term.courses.first.title, 'a'
      assert_equal term.courses.last.title, 'x'
    end

    should 'show all active and last 10 archived terms' do
      create_list(:term, 10)
      create_list(:term, 20, end_date: Date.today - 2.months, start_date: Date.today - 1.year)

      get terms_path

      assert_response :success
      terms = assigns(:terms)
      archived_terms = assigns(:archived_terms)

      assert terms, "terms can't be null"
      assert archived_terms, "archived terms can't be null"

      assert_equal 10, terms.size, 'Active terms should show all'
      assert_equal 10, archived_terms.size, 'Archived should only show max 10'
    end

    should 'not return courses if the term is expired when searching' do
      term = create(:term, name: 'expired', start_date: Date.today - 1.year, end_date: Date.today - 2.months)
      create(:course, title: 'search for me', term:)

      get search_courses_terms_path, params: { q: 'search' }

      assert_response :success
      courses = assigns(:courses)
      assert_equal 0, courses.size
    end
  end
end
