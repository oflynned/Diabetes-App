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

        # let's start off with working with just the first sheet
        for sheet_index in range(1):
            sheet = workbook.sheet_by_index(sheet_index)

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
            warning_note = {"warning_note": warning_note}

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

                for i in range(0, sheet.nrows):
                    for j in range(min_row, max_row):
                        if len(headings) == 4:
                            # normal suggestion
                            pass
                        else:
                            # extra parameter in col 4
                            pass

            return data_ranges

    @staticmethod
    def groom_content():
        epoch_0_30 = 0
        epoch_30_60 = 30
        epoch_60_150 = 60
        epoch_gr_150 = 150

        return Excel.__retrieve_data_sheets()
