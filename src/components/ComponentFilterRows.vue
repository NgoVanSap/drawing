<template>
  <div v-if="isActiveComponent" class="main_ui">
    <div class="main_content">
      <div class="top_ui">
        <div class="top_title">{{ $t("FilterRows") }}</div>
        <div class="top_icon">
          <i class="fas fa-times close-icon" @click="handleClose"></i>
        </div>
      </div>
      <div class="center_ui">
        <div class="center_item center_title">
          <div class="center_label">{{ $t("Title") }}</div>
          <input type="text" class="input" ref="inputTitle" v-model="valueTitle" />
          <div class="title_option">
            <select class="form-select" style="font-size: 14px" v-model="selectedTitle">
              <option value="Equals">{{ $t("Equals") }}</option>
              <option value="Does not equals">{{ $t("DoesNotEquals") }}</option>
              <option value="Begin with">{{ $t("BeginWith") }}</option>
              <option value="Does not begin with">{{ $t("DoesNotBeginWith") }}</option>
              <option value="End with">{{ $t("EndWith") }}</option>
              <option value="Does not end with">{{ $t("DoesNotEndWith") }}</option>
              <option value="Contains">{{ $t("Contains") }}</option>
              <option value="Does not contains">{{ $t("DoesNotContains") }}</option>
            </select>
          </div>
        </div>
        <div class="center_item center_last_checkin">
          <div class="center_label">{{ $t("DateAccessed") }}</div>
          <div class="date_time">
            <VueDatePicker
              v-model="selectedDate"
              :format="customDateFormat"
            ></VueDatePicker>
          </div>
        </div>
        <div class="center_item center_author">
          <div class="center_label">{{ $t("Author") }}</div>
          <input type="text" class="input" ref="inputAuthor" v-model="valueAuthor" />
        </div>
        <div class="center_item center_status">
          <div class="center_label">{{ $t("Status") }}</div>
          <div class="status_option">
            <select class="form-select" v-model="selectedStatus">
              <option selected value="Ready">{{ $t("Ready") }}</option>
              <option value="Busy">{{ $t("Busy") }}</option>
            </select>
          </div>
        </div>
        <div class="center_item center_version">
          <div class="center_label">{{ $t("Version") }}</div>
          <input type="text" class="input" ref="inputVersion" v-model="valueVersion" />
        </div>
        <div class="center_item center_size">
          <div class="center_label">{{ $t("SizeFrom") }}</div>
          <input
            type="text"
            class="inputSize"
            ref="inputSize"
            v-model="valueSizeFrom"
            @input="validateInput"
          />
          <div class="title_option_size">
            <select
              class="form-select"
              style="width: 190px; font-size: 14px"
              v-model="selectedSizeFrom"
            >
              <option selected value="Bytes">Bytes</option>
              <option value="KB">KB</option>
              <option value="MB">MB</option>
              <option value="GB">GB</option>
              <option value="TB">TB</option>
            </select>
          </div>
        </div>

        <div class="center_item center_size">
          <div class="center_label">{{ $t("SizeTo") }}</div>
          <input
            type="text"
            class="inputSize"
            ref="inputSize"
            v-model="valueSizeTo"
            @input="validateInput"
          />
          <div class="title_option_size">
            <select
              class="form-select"
              style="width: 190px; font-size: 14px"
              v-model="selectedSizeTo"
            >
              <option selected value="Bytes">Bytes</option>
              <option value="KB">KB</option>
              <option value="MB">MB</option>
              <option value="GB">GB</option>
              <option value="TB">TB</option>
            </select>
          </div>
        </div>

        <div class="center_item center_autom_rev">
          <div class="center_label">{{ $t("AutomRev") }}</div>
          <input type="text" class="input" ref="inputAutomRev" v-model="valueAutomRev" />
        </div>
        <div class="center_item center_description">
          <div class="center_label">{{ $t("Description") }}</div>
          <input
            type="text"
            class="input"
            ref="inputDescription"
            v-model="valueDescription"
          />
        </div>
        <div class="center_item center_document_number">
          <div class="center_label_document">{{ $t("DocumentNumber") }}</div>
          <input
            type="text"
            class="input"
            ref="DocumentNumber"
            v-model="valueDocumentNumber"
            :style="{ 'margin-left': '6px' }"
          />
        </div>
      </div>
      <div class="bottom_ui">
        <v-btn
          class="button_ok"
          @click="handleOk"
          style="font-family: 'Poppins', sans-serif"
          >{{ $t("Filter") }}</v-btn
        >
        <v-btn
          class="button_cancel"
          @click="HandleCancel"
          style="font-family: 'Poppins', sans-serif"
          >{{ $t("Cancel") }}</v-btn
        >
      </div>
    </div>
  </div>
</template>

<script>
import moment from "moment";
import VueDatePicker from "@vuepic/vue-datepicker";
import "@vuepic/vue-datepicker/dist/main.css";
export default {
  name: "component-filter-rows",
  components: {
    VueDatePicker,
  },
  props: {
    isActiveComponent: {
      type: Boolean,
      request: true,
      default: false,
    },
  },
  data() {
    return {
      valueTitle: "",
      valueAuthor: "",
      selectedDate: new Date(),
      customDateFormat: "dd-MM-yyyy",
      valueSizeFrom: "",
      valueSizeTo: "",
      selectedSizeFrom: "Bytes",
      selectedSizeTo: "Bytes",
      selectedTitle: "Equals",
      selectedStatus: "Ready",
      valueVersion: "",
      valueAutomRev: "",
      valueDescription: "",
      valueDocumentNumber: "",
    };
  },
  methods: {
    formatDate() {
      let datetime = new Date();
      return "[" + moment(datetime).format("DD-MM-YYYY HH:mm:ss.SSS") + "]";
    },
    handleOk() {
      console.log(this.formatDate(), "[ComponentFilterRows] signal handleOk");
      const title = this.valueTitle;
      const author = this.valueAuthor;
      const version = this.valueVersion;
      const size_from = this.valueSizeFrom;
      const size_to = this.valueSizeTo;
      const autom_rev = this.valueAutomRev;
      const description = this.valueDescription;
      const document_number = this.valueDocumentNumber;

      const last_check_in_day = this.selectedDate.getDate();
      const last_check_in_month = this.selectedDate.getMonth() + 1;
      const last_check_in_year = this.selectedDate.getFullYear();

      console.log(
        this.formatDate(),
        "[ComponentFilterRows] title: ",
        title,
        this.selectedTitle
      );
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] last_check_in: ",
        last_check_in_day,
        "-",
        last_check_in_month,
        "-",
        last_check_in_year
      );
      console.log(this.formatDate(), "[ComponentFilterRows] author: ", author);
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] status: ",
        this.selectedStatus
      );
      console.log(this.formatDate(), "[ComponentFilterRows] version: ", version);
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] size_from: ",
        size_from,
        this.selectedSizeFrom
      );
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] size_to: ",
        size_to,
        this.selectedSizeTo
      );
      console.log(this.formatDate(), "[ComponentFilterRows] autom_rev: ", autom_rev);
      console.log(this.formatDate(), "[ComponentFilterRows] description: ", description);
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] document number: ",
        document_number
      );

      this.$globalVariable.FILTER_ROWS.title_value = title;
      this.$globalVariable.FILTER_ROWS.title_option = this.selectedTitle;
      this.$globalVariable.FILTER_ROWS.last_check_in_day = last_check_in_day;
      this.$globalVariable.FILTER_ROWS.last_check_in_month = last_check_in_month;
      this.$globalVariable.FILTER_ROWS.last_check_in_year = last_check_in_year;
      this.$globalVariable.FILTER_ROWS.author = author;
      this.$globalVariable.FILTER_ROWS.status = this.selectedStatus;
      this.$globalVariable.FILTER_ROWS.version = version;
      this.$globalVariable.FILTER_ROWS.size_from_value = size_from;
      this.$globalVariable.FILTER_ROWS.size_from_option = this.selectedSizeFrom;
      this.$globalVariable.FILTER_ROWS.size_to_value = size_to;
      this.$globalVariable.FILTER_ROWS.size_to_option = this.selectedSizeTo;
      this.$globalVariable.FILTER_ROWS.autom_rev = autom_rev;
      this.$globalVariable.FILTER_ROWS.description = description;
      this.$globalVariable.FILTER_ROWS.document_number = document_number;

      let day_text = last_check_in_day;
      if (last_check_in_day < 10) {
        day_text = "0" + last_check_in_day;
      }
      let day_month = last_check_in_month;
      if (last_check_in_month < 10) {
        day_month = "0" + last_check_in_month;
      }

      const last_check_in = day_text + "." + day_month + "." + last_check_in_year;
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] last_check_in: ",
        last_check_in
      );
      this.$globalVariable.FILTER_ROWS.last_check_in = last_check_in;

      this.$emit("signalOk");
    },
    HandleCancel() {
      console.log(this.formatDate(), "[ComponentFilterRows] signal HandleCancel");
      this.valueTitle = "";
      this.valueAuthor = "";
      this.selectedDate = new Date();
      this.customDateFormat = "dd-MM-yyyy";
      this.valueSizeFrom = "";
      this.valueSizeTo = "";
      this.selectedSizeFrom = "Bytes";
      this.selectedSizeTo = "Bytes";
      this.selectedTitle = "Equals";
      this.selectedStatus = "Ready";
      this.valueVersion = "";
      this.valueAutomRev = "";
      this.valueDescription = "";
      this.valueDocumentNumber = "";
      this.$emit("signalClose");
    },
    handleClose() {
      console.log(this.formatDate(), "[ComponentFilterRows] signal handleClose");
      this.$emit("signalClose");
    },
    validateInput() {
      this.valueSizeFrom = this.valueSizeFrom.replace(/[^0-9]/g, "");
      this.valueSizeTo = this.valueSizeTo.replace(/[^0-9]/g, "");
    },
  },
  computed: {},
  watch: {},
};
</script>

<style scoped>
@import "@mdi/font/css/materialdesignicons.min.css";

/* CSS to MAIN UI */
.main_ui {
  font-family: "Roboto", sans-serif;
  font-size: 14px;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
}

.main_content {
  font-family: Arial, Helvetica, sans-serif;
  background-color: #fff;
  padding: 0;
  border-radius: 6px;
  width: 750px;
}

/* CSS to TOP UI */
.top_ui {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #000;
  border: none;
  border-top-left-radius: 6px;
  border-top-right-radius: 6px;
  padding-right: 5px;
  color: #fff;
  height: 50px;
}

.top_title {
  flex: 1;
  height: 40px;
  padding-top: 10px;
  padding-left: 20px;
  border-radius: 5px;
  text-align: left;
  /* font-weight: bold; */
  font-size: 16px;
}

.top_icon {
  cursor: pointer;
  margin-right: 10px;
  color: #fff;
}

.top_icon i {
  font-size: 16px;
  color: #fff;
}

.top_icon i:hover {
  font-size: 16px;
  color: #757575;
}

/* CSS to CENTER UI */
.center_ui {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 10px;
  padding-top: 15px;
  border: 1px solid none;
  width: 100%;
  height: calc(100% - 115px);
  background-color: #fff;
}

.center_item {
  display: flex;
  border: 1px solid none;
  height: 45px;
  width: 100%;
}

.center_label {
  border: 1px solid none;
  height: 100%;
  width: 125px;
  justify-content: center;
  text-align: left;
  vertical-align: middle;
  padding-top: 10px;
  padding-left: 15px;
}
.center_label_document {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: left;
  vertical-align: middle;
  padding-left: 15px;
  width: 119px;
}

.input {
  border: 1px solid #ccc;
  width: 400px;
  height: 40px;
  border-radius: 3px;
  padding: 10px;
  font-size: 16px;
  color: #333;
  background-color: #fff;
  margin-top: 1px;
  margin-bottom: 25px;
  margin-right: 10px;
}

.input:focus {
  outline: none;
  border-color: #4caf50;
  box-shadow: 0 0 4px #4caf50;
}

.inputSize {
  border: 1px solid #ccc;
  width: 200px;
  height: 40px;
  border-radius: 3px;
  padding: 10px;
  font-size: 16px;
  color: #333;
  background-color: #fff;
  margin-top: 1px;
  margin-bottom: 25px;
  margin-right: 10px;
}

.inputSize:focus {
  outline: none;
  border-color: #4caf50;
  box-shadow: 0 0 4px #4caf50;
}

.title_option {
  border: 1px solid none;
  margin-top: 2px;
  width: 190px;
}

.title_option_size {
  border: 1px solid none;
  margin-top: 2px;
  width: 192px;
}

.status_option {
  border: none;
  margin-top: 2px;
  width: 400px;
}

.date_time {
  display: flex;
  border: 1px solid none;
  justify-content: center;
  width: 400px;
}

/* CSS to BOTTOM UI */
.bottom_ui {
  display: flex;
  height: 65px;
  width: 100%;
  justify-content: center;
  color: #fff;
  padding-top: 10px;
  padding-bottom: 15px;
  border: none;
}

.button_ok {
  margin-right: 15px;
  min-width: 110px;
}

.button_cancel {
  margin-left: 15px;
  min-width: 110px;
}
</style>
