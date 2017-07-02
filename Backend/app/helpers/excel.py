import xlrd
import json


class Excel:
    @staticmethod
    def __get_working_dir(file_name):
        return "app/datasets/" + file_name

    @staticmethod
    def __retrieve_data_sheets():
        dataset_file_name = "app_sug_2.xlsx"
        dataset_location = Excel.__get_working_dir(dataset_file_name)

        workbook = xlrd.open_workbook(dataset_location)
        raw_data = []

        # iterate over the sheets to save each to its own json representation
        for sheet_index in range(1):
            sheet = workbook.sheet_by_index(7)

            # let's get the heading names first so we know
            # sheet details for later on
            headings = []
            for r in range(1, 2):  # sheet.nrows):
                row_value = sheet.row_values(r)
                for index, item in enumerate(row_value):
                    if item is not '':
                        headings.append(item.strip())

            # iterate along the 0th col per row to get displacement
            # of how many suggestions there are by differencing
            exclusion_factors = ['', 'Exercise type']
            data_ranges = []

            i = 2
            for r in range(2, sheet.nrows):
                row_value = sheet.row_values(r)
                row_value = row_value[0].strip()
                if row_value not in exclusion_factors:
                    data_ranges.append([row_value, i])

                # iterate to give max as only min exists
                # [exercise type, min row, max row]

                for index, item in enumerate(data_ranges):
                    if index < len(data_ranges) - 1:
                        data_ranges[index].append(data_ranges[index + 1][1])
                        data_ranges[index] = data_ranges[index][:3]

                i += 1

            warning_note = data_ranges[len(data_ranges) - 1][0]

            # don't need the warning anymore so we pop it
            data_ranges.pop()

            # now we've the ranges and the data to link
            for exercise in data_ranges:
                min_row = exercise[1]
                max_row = exercise[2]

                # iterate two-dimensionally over the x and y axes
                # type, intensity, duration and suggestion are common
                # 4 cols indicates the sheet is normal, 5 cols indicate an extra parameter in col 4
                # where the suggestion is then given in col 5
                # the 4th and 5th cols together should form the suggestion object

                data_object = {}
                groomed = []
                suggestions = []
                heading_exclusions = ['', 'Suggestions']

                is_parametrised = (len(headings) > 4)

                # extra parameter in col 4
                for data_row in range(min_row, max_row):
                    data = sheet.row_values(data_row, 0, 5)
                    for index, row_value in enumerate(data):
                        # before meal, after meal, don't care
                        # * indicates showing a warning with the suggestion

                        if index == 3 and row_value == '':
                            data[index] = "always"

                        if row_value is not '':
                            row_value = row_value.strip()
                            groomed.append(row_value)

                    if is_parametrised:
                        parameter_content = data[3].strip()
                        suggestion_content = data[4].strip()

                        if suggestion_content not in heading_exclusions:
                            suggestion_object = {}

                            # if there is an astrix, append a warning
                            if parameter_content == "*":
                                suggestion_object["warning"] = warning_note

                            parameter_name = str(headings[3]).replace("/", " ")
                            parameter_name = Excel.__groom_titles(parameter_name)

                            suggestion_object[parameter_name] = Excel.__groom_titles(parameter_content)

                            if suggestion_content == "*":
                                suggestion_content = "always"
                            suggestion_object["exercise_suggestion"] = suggestion_content

                            suggestions.append(suggestion_object)

                if is_parametrised:
                    data_object["exercise_meal_suggestions"] = suggestions

                data_object["exercise_type"] = Excel.__groom_titles(groomed[0])
                data_object["exercise_intensity"] = Excel.__split_tags(Excel.__groom_titles(groomed[1]))
                data_object["exercise_duration"] = Excel.__groom_duration_timings(groomed[2])

                raw_data.append(data_object)
            return raw_data

    @staticmethod
    def __groom_info_page(data):
        pass

    @staticmethod
    def __groom_duration_timings(timing):
        EPOCH_0_30 = 0
        EPOCH_30_60 = 1
        EPOCH_60_150 = 2
        EPOCH_GR_150 = 3

        timings = Excel.__split_tags(timing)
        formatted_timings = []

        for i in range(len(timings)):
            timing = timings[i].strip()

            if timing == "0-30mins":
                timing = EPOCH_0_30
            elif timing == "30-60mins":
                timing = EPOCH_30_60
            elif timing == "60-150mins":
                timing = EPOCH_60_150
            elif timing == ">150mins":
                timing = EPOCH_GR_150

            formatted_timings.append(timing)

        return formatted_timings

    @staticmethod
    def __groom_titles(title):
        return str(title).replace(" ", "_").lower()

    @staticmethod
    def __split_tags(tags):
        return str(tags).split("/")

    @staticmethod
    def groom_content():
        return Excel.__retrieve_data_sheets()