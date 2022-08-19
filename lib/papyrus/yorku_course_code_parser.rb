module Papyrus
  ## SAMPLE 2016_AP_POLS_Y_1000__6_C_EN_A_LECT_01, 2016_AP_POLS_Y_1000__6_C_EN_A_TUTR_04, 2016_AP_HRM_F_3422__3_B_EN_A_LECT_01
  # 2016_GS_CDIS_F_5110__3_A_EN_A_SEMR_01,
  # 2016_GS_CDIS_S2_5075__3_B_EN_A_ONLN_01,
  # 2016_GS_CDIS_W_5120__3_M_EN_A_SEMR_01,
  # 2016_GS_CDIS_Y_5100__6_A_EN_A_SEMR_01,
  # 2016_GS_EDUC_SU_5715__3_A_EN_A_SEMR_01,
  # 2016_GS_GFWS_SU_6801A_3_A_EN_A_DIRD_01  <<<<<<<<< THIS IS ANOTHER VERSION OF THE CODE

  class YorkuCourseCodeParser
    EXTENDED_UNDERSCORE_COUNT = 11
    FULL_UNDERSCORE_COUNT = 9

    ## Ensures the code is a valid code
    ## Simple string length and underscore count checks.
    def valid?(code)
      ## nil or empty return false right away
      return false if code.nil? || code.size == 0

      return true if code.count('_') >= FULL_UNDERSCORE_COUNT && code.count('_') <= EXTENDED_UNDERSCORE_COUNT

      # doesn't match any, return false right away
      false
    end

    ## Takes 2016_AP_POLS_Y_1000__6_C_EN_A_LECT_01 and makes it 2016_AP_POLS_Y_1000__6_C_EN_A
    def unique_code(extended_code)
      if valid?(extended_code)
        if extended_code.count('_') == EXTENDED_UNDERSCORE_COUNT
          return extended_code.split('_')[0..FULL_UNDERSCORE_COUNT].join('_')
        end
        if extended_code.count('_') == (EXTENDED_UNDERSCORE_COUNT - 1)
          return extended_code.split('_')[0..FULL_UNDERSCORE_COUNT].join('_')
        end
        return extended_code if extended_code.count('_') == FULL_UNDERSCORE_COUNT
      end

      extended_code
    end

    ## TAKES A LIST 2016_AP_POLS_Y_1000__6_C_EN_A_LECT_01, 2016_AP_POLS_Y_1000__6_C_EN_A_TUTR_04 and returns 2016_AP_POLS_Y_1000__6_C_EN_A
    def unique_codes_only(code_list, separator = ',')
      unique_list = []

      if !code_list.nil? && code_list.split('_').size >= FULL_UNDERSCORE_COUNT
        code_list.split(separator).each do |code|
          unique_list.push(unique_code(code.strip)) if valid?(code.strip)
        end
      end

      unique_list.uniq
    end

    ## Takes 2016_AP_POLS_Y_1000__6_C_EN_A_LECT_01 and retursn POLS_1000
    def short_code(code)
      if valid?(code)
        "#{get_value_from_code(code, 2)}_#{get_value_from_code(code, 4)}"
      else
        code
      end
    end

    def code_year(code)
      get_value_from_code(code, 0)
    end

    def code_term(code)
      get_value_from_code(code, 3)
    end

    def term_details(code)
      # F W FW Y S SU S1 S2
      year = code_year(code).to_i

      case code_term(code).upcase
      when 'F'
        term_name = "Fall #{year}"
        start_date = Date.parse("#{PapyrusSettings.term_fall_start}, #{year}")
        end_date = Date.parse("#{PapyrusSettings.term_fall_end}, #{year}")
      when 'W'
        term_name = "Winter #{year + 1}"
        start_date = Date.parse("#{PapyrusSettings.term_winter_start}, #{year + 1}")
        end_date = Date.parse("#{PapyrusSettings.term_winter_end}, #{year + 1}")
      when 'FW', 'Y'
        term_name = "Year #{year}-#{year + 1}"
        start_date = Date.parse("#{PapyrusSettings.term_year_start}, #{year}")
        end_date = Date.parse("#{PapyrusSettings.term_year_end}, #{year + 1}")
      when 'S', 'SU', 'S1', 'S2'
        term_name = "Summer #{year + 1}"
        start_date = Date.parse("#{PapyrusSettings.term_summer_start}, #{year + 1}")
        end_date = Date.parse("#{PapyrusSettings.term_summer_end}, #{year + 1}")
      else
        term_name = "Year #{year}-#{year + 1}"
        start_date = Date.parse("#{PapyrusSettings.term_year_start}, #{year}")
        end_date = Date.parse("#{PapyrusSettings.term_year_end}, #{year + 1}")
      end

      term = {}
      term[:year] = year
      term[:name] = term_name
      term[:start_date] = start_date
      term[:end_date] = end_date

      term
    end

    private

    def get_value_from_code(code, position)
      code = '_______'   if code.blank?
      code.split('_')[position]
    end
  end
end
