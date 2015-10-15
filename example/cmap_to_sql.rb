require '/Users/malarcon/medivo/cmap/lib/cmap.rb'
require 'pry'

class PpdmVelmaCode
  attr_reader :propositions_to_sql,:condition

  def initialize(propositions_to_sql,condition)
    @propositions_to_sql = propositions_to_sql
    @condition = condition
  end

	def extract_create_sql
    "create table extracts.#{condition} (\n  lab_result_id integer,\n  input_filename varchar(255),\n  patient_id varchar(255),\n  patient_gender varchar(255),\n  patient_date_of_birth varchar(255),\n  patient_state varchar(255),\n  diagnosis_codes varchar(255),\n  test_result_name varchar(255),\n  test_result_value varchar(255),\n  test_result_abnormal_flag varchar(255),\n  ordering_provider_npi_number varchar(255),\n  ordering_provider_first_name varchar(255),\n  ordering_provider_last_name varchar(255),\n  ordering_practice_lab_account_number varchar(255),\n  ordering_practice_address_line_1 varchar(255),\n  ordering_practice_zip_code varchar(255),\n\n  test_result_name_stnd varchar(128),\n  test_result_value_numeric_stnd numeric(23,5),\n  test_observation_reported_date varchar(255),\n  test_specimen_draw_date varchar(255),\n  test_specimen_receipt_date varchar(255),\n  diag_1 varchar(16),\n  diag_2 varchar(16),\n  diag_3 varchar(16),\n  diag_4 varchar(16),\n  account_type varchar(255),\n  provider_type varchar(255)\n);"
	end

	def extract_select_sql
		extract_select = "select lab_result_id, input_filename, token4 as patient_id, patient_gender, patient_date_of_birth, patient_state, diagnosis_codes, test_result_name, test_result_value, test_result_abnormal_flag, ordering_provider_npi_number, ordering_provider_first_name, ordering_provider_last_name, ordering_practice_lab_account_number, ordering_practice_address_line_1, ordering_practice_zip_code, test_result_name_stnd, test_result_value_numeric_stnd, test_observation_reported_date, test_specimen_draw_date, test_specimen_receipt_date, diag_1, diag_2, diag_3, diag_4, account_type, provider_type from analytics.lab_result where "
		results_of_interest = propositions_to_sql.sanitized_graph.children(propositions_to_sql.table_name)
    vertices_of_results = propositions_to_sql.sanitized_graph.edges.select{|e| results_of_interest.include? e.destination_vertex}
    fields = vertices_of_results.map {|e| "#{e.value}" }.join(" or ")
    "#{extract_select}\n#{fields}\n;"
	end

  def transform_sql
    transform_header = "set search_path to datamarts;\nDROP TABLE IF EXISTS ai_ppdm_acr; \nCREATE TABLE ai_ppdm_acr\nAS\nSELECT  ROW_NUMBER() OVER (ORDER BY patient_id,test_observation_reported_date,lab_result_id) AS record_number,\nDENSE_RANK() OVER (PARTITION BY patient_id ORDER BY test_observation_reported_date ASC,test_result_name_stnd,lab_result_id) AS record_number_asc,\nDENSE_RANK() OVER (PARTITION BY patient_id ORDER BY test_observation_reported_date DESC,test_result_name_stnd,lab_result_id) AS record_number_desc,\nlab_result_id,\ninput_filename,\npatient_id,\nmd5(test_observation_reported_date||patient_id) patient_date_id,\npatient_gender,\npatient_date_of_birth as patient_birth_year,\nCASE WHEN left(test_observation_reported_date,4) = '' then null\nELSE left(test_observation_reported_date,4)::numeric - patient_date_of_birth::numeric END as patient_age,\npatient_state,\ntest_result_name_stnd,\ntest_result_name,\nCASE WHEN test_result_value_numeric_stnd is null and test_result_value like '%<%' or test_result_value like '%>%' then replace(case WHEN test_result_value ~* '< ?[0-9]+ ?not detected' then '0' ELSE regexp_substr(test_result_value,'[0-9]+(\.[0-9]+)? ?') end,',','') *1.00\n  WHEN test_result_value_numeric_stnd is null and test_result_value like '%E6' then replace(test_result_value,'E6','')*1000000.00\n  WHEN test_result_value_numeric_stnd is null and test_result_value like '%E5' then replace(test_result_value,'E5','')*100000.00\n  WHEN test_result_value_numeric_stnd is null and test_result_value like '%E4' then replace(test_result_value,'E4','')*10000.00\n  WHEN test_result_value_numeric_stnd is null and test_result_value ~* 'not detected' then 0.00\n  WHEN test_result_value_numeric_stnd is null and test_result_value ~* 'detected' then 1.00\nELSE test_result_value_numeric_stnd end test_result_num,\ntest_result_value,\ntest_result_abnormal_flag as test_abnorm_flag,\nTO_DATE(CASE WHEN test_observation_reported_date = '' THEN test_specimen_receipt_date ELSE test_observation_reported_date END,'YYYYMMDD') test_observation_reported_date_dt,\nLEFT (CASE WHEN test_observation_reported_date = '' THEN test_specimen_receipt_date ELSE test_observation_reported_date END,6)*1 test_observation_reported_date_yyyymm,\nTO_DATE(test_specimen_draw_date,'YYYYMMDD') test_specimen_draw_date_dt,\nmd5(coalesce(ordering_provider_npi_number,'')|| coalesce(ordering_provider_first_name,'')||coalesce(ordering_provider_last_name,'')) provider_id,\nordering_practice_lab_account_number practice_id,\nCASE\n  WHEN lower(account_type) IN ('other','jail','military','n/a',' ','deleted account') THEN 'Non-Reference'\n  WHEN account_type is null THEN 'Non-Reference'\n  WHEN lower(account_type) IN ('lab') THEN 'Reference'\n  WHEN lower(account_type) IN ('foreign') THEN 'Non-USA'\n  ELSE 'UNMAPPED' ||account_type\n   END account_type_val,\nprovider_type,\ndiag_1 as icd9_primary,\ndiag_2 as icd9_secondary,\ndiag_3 as icd9_third,\ndiag_4 as icd9_fourth,\nordering_practice_address_line_1 IS NOT NULL has_practice_info,\n((ordering_provider_first_name IS NOT NULL AND ordering_provider_last_name IS NOT NULL) OR ordering_provider_npi_number IS NOT NULL) has_provider_info,\nordering_provider_npi_number <> '' has_npi,\nordering_practice_zip_code\nFROM extracts.#{condition};\n"
    transform_body = propositions_to_sql.queries.join("\n")
    "#{transform_header}\n#{transform_body}\n;"
  end

  def transform_qa_sql
    transform_qa_header = "set search_path to datamarts; \nselect "
    fields_to_sum= propositions_to_sql.sanitized_graph.vertices.select {|v| v != propositions_to_sql.table_name}
    transform_body = fields_to_sum.map {|e| "sum(#{e}) #{e}" }.join(", ")
    transform_body_from ="from #{propositions_to_sql.table_name}"
    "#{transform_qa_header}\n#{transform_body}\n#{transform_body_from};"
  end

end


if ARGV.empty?
  puts "USAGE: #{$0} <CONDITION>"
  exit
end

condition = ARGV[0]


propositions_path = File.expand_path("./"+condition+".txt", File.dirname(__FILE__))

subquery_gsubs = [
  ["prior history of", "update +table_name+ set +destination_vertex+=(SELECT count(*)  FROM +table_name+ n1 WHERE n1.patient_id = +table_name+.patient_id AND n1.test_specimen_draw_date_dt <+table_name+.test_specimen_draw_date_dt AND +origin_vertex+=1)>0;"],
  ["equals", "update +table_name+ set +destination_vertex+= +origin_vertex+;"],
  ["order has","update +table_name+ set +destination_vertex+=(SELECT max(+origin_vertex+)  FROM +table_name+ n1 WHERE n1.patient_id = +table_name+.patient_id AND n1.order_id = +table_name+.order_id );"]
]

root_name = "ai_ppdm_"+condition
args = {
  propositions_path: propositions_path,
  table_name: root_name,
  subquery_gsubs: subquery_gsubs
}

propositions_to_sql = Cmap::PropositionsToSql.new(args)

puts "\n\n\nQUERY patient_profile/extracts/#{condition}/select.sql"

#extract_select = "select lab_result_id, input_filename, token4 as patient_id, patient_gender, patient_date_of_birth, patient_state, diagnosis_codes, test_result_name, test_result_value, test_result_abnormal_flag, ordering_provider_npi_number, ordering_provider_first_name, ordering_provider_last_name, ordering_practice_lab_account_number, ordering_practice_address_line_1, ordering_practice_zip_code, test_result_name_stnd, test_result_value_numeric_stnd, test_observation_reported_date, test_specimen_draw_date, test_specimen_receipt_date, diag_1, diag_2, diag_3, diag_4, account_type, provider_type from analytics.lab_result where 1=0 "

ppdm_extract_code = PpdmVelmaCode.new(propositions_to_sql,condition)

puts "\n\n\n################################\nSQL - EXTRACT CREATE - #{root_name}\n################################\n"
puts ppdm_extract_code.extract_create_sql

puts "\n\n\n################################\nSQL - EXTRACT SELECT - #{root_name}\n################################\n"
puts ppdm_extract_code.extract_select_sql

puts "\n\n\n################################\nSQL - TRANSFORM - #{root_name}\n################################\n"
puts ppdm_extract_code.transform_sql

puts "\n\n\n################################\nSQL - TRANSFORM QA - #{root_name}\n################################\n"
puts ppdm_extract_code.transform_qa_sql

#binding.pry
