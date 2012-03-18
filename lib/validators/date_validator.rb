class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if Time.zone.parse(value.to_s).nil?
      record.errors.add attribute, I18n.t('grade_entry_forms.invalid_date')
      return false
    end
  end
end