require 'date'
require_relative 'cholqij/version'
require_relative 'cholqij/yml_output'

class Cholqij
  class Error < StandardError; end

  BASE_GMT584285 = :gmt_584285
  BASE_GMT584283 = :gmt_584283
  BASE_GMT584283_J = Date.parse('-3113-09-06')
  BASE_GMT584285_J = Date.parse('-3113-09-08')
  KN  = 1
  WN  = 20
  TN  = WN * 18
  KT  = TN * 20
  BKT = KT * 20
  PKT = BKT * 13
  DIGITS = [KN, WN, TN, KT, BKT, PKT].freeze

  # Tolkin Const
  TZOLKIN_MONTH       = (1..13).to_a
  TZOLKIN_MONTH_HOSEI = 3
  TZOLKIN_DAY         = %w(Imix I'k Ak'bal Kan Chickchan Kimi Manik' Lamat Muluk Ok Chuwen Eb Ben Ix Men Kib Kaban Etz'nab Kawak Ajaw)
  TZOLKIN_DAY_HOSEI   = 19
  # Haab Const
  HAAB_MONTH = %w(Pop Wo Sip Sots Sek Xul Yaxk'in Mol Che'n Yax Sak Keh Mak K'ank'in Muwan Pax K'ayab Kumk'u)
  HAAB_DAYS  = (1..20).to_a
  WAYEB_DAYS = (1..5).to_a
  HAAB_BASE_HOSEI  = 347
  HAAB_DAY_COUNT   = 365

  class << self
    def lc_to_cal(lc, gmt_mode=:gmt_584283)
      lc_arr = lc.split('.').map(&:to_i)
      i = 0
      sum = 0
      while lc_arr.size > 0 do
        n = lc_arr.pop
        e = DIGITS[i]
        sum += n*e
        i += 1
      end
      Date.jd + coef(gmt_mode) + sum
    end
    def cal_to_lc(cal, gmt_mode=:gmt_584283)
      coef_value = coef(gmt_mode)
      base = cal.jd - coef_value
      lc_value = DIGITS.map.with_index(1){|e,i| [e, DIGITS[i]] }.map{|a,b|
        (b.nil? ? base : (base % b)) / a
      }.reverse
      lc = if lc_value[0] == 1 && lc_value[1] == 0
        [0,13,lc_value[2],lc_value[3],lc_value[4],lc_value[5]]
      else
        lc_value
      end
      # 最上位桁が0だったら外す
      lc.join('.').gsub(/\A0\./, '')
    end
    def coef(gmt_mode)
      gmt_mode == BASE_GMT584283 ? BASE_GMT584283_J.jd : BASE_GMT584285_J.jd
    end
    def cal_to_tzolkin(cal, gmt_mode=:gmt_584283)
      base = cal.jd - coef(gmt_mode)
      month = TZOLKIN_MONTH[(base + TZOLKIN_MONTH_HOSEI) % TZOLKIN_MONTH.size]
      day   = TZOLKIN_DAY[(base + TZOLKIN_DAY_HOSEI) % TZOLKIN_DAY.size]
      "#{month}#{day}"
    end
    def cal_to_haab(cal, gmt_mode=:gmt_584283)
      base = cal.jd - coef(gmt_mode) + HAAB_BASE_HOSEI
      day_position = base % HAAB_DAY_COUNT
      if day_position >= 360
        month = 'Wayeb'
        day   = day_position - 360
      else
        month = HAAB_MONTH[day_position / 20]
        day   = HAAB_DAYS[day_position % 20]
      end
      "#{day}#{month}"
    end
    def cal_to_full(cal, gmt_mode=:gmt_584283)
      "#{cal_to_lc(cal, gmt_mode)} #{cal_to_tzolkin(cal, gmt_mode)} #{cal_to_haab(cal, gmt_mode)} (#{cal.strftime("%Y-%m-%d")})"
    end
    def lc_to_full(lc, gmt_mode=:gmt_584283)
      cal = lc_to_cal(lc, gmt_mode)
      cal_to_full(cal, gmt_mode)
    end
    alias :from_date :cal_to_full
    alias :from_lc :lc_to_full
  end
end
