<template>
  <div class="custom-menu" :style="{ top: y + 'px', left: x + 'px' }">
    <ul>
      <li
        class="custom-menu-preview"
        @click="handlePreview"
        :class="{ disabled: isCheckFile }"
      >
        <i class="icon-preview" @click="handlePreview"></i>{{ $t("Preview") }}
      </li>
      <li
        class="custom-menu-download"
        :class="{ disabled: checkTab }"
        @click="handleDownload"
      >
        <i class="icon-download" @click="handleDownload"></i>{{ $t("Download") }}
      </li>
      <li class="custom-menu-highlight" @click="handleHighlight">
        <i class="icon-highlight" @click="handleHighlight"></i>{{ $t("Highlight") }}
      </li>
      <li class="custom-menu-highlight-color" @click="handleHighlightColor">
        <i class="icon-highlight-color" @click="handleHighlightColor"></i
        >{{ $t("ChooseColor") }}
      </li>
      <li
        class="custom-menu-save-list"
        :class="{ disabled: checkTab }"
        @click="handleSaveList"
      >
        <i class="icon-save-list" @click="handleSaveList"></i>{{ $t("SaveList") }}
      </li>
      <!-- <input type="color" ref="colorPicker" v-model="this.$globalVariable.COLOR" style="display: none;" @input="colorPickerChanged" /> -->
    </ul>
    <v-dialog v-model="dialogFormChooseColor" persistent width="300">
      <v-card>
        <v-form v-model="isFormChangePassword">
          <v-card-title style="background: black; color: white">
            <span
              class="text-h5"
              style="padding-bottom: 20px; font-size: 14px !important; font-weight: 700"
              >{{ $t("ChooseColor") }}</span
            >
          </v-card-title>
          <div>
            <ColorPicker
              :color="this.$globalVariable.COLOR"
              @color-change="updateColor"
            />
          </div>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn
              class="elevation-2"
              variant="text"
              @click="
                dialogFormChooseColor = false;
                isSnackbar = false;
              "
              style="font-family: 'Poppins', sans-serif"
            >
              {{ $t("Close") }}
            </v-btn>
            <v-btn
              class="elevation-2"
              variant="text"
              @click="handleSaveChooseColor"
              style="font-family: 'Poppins', sans-serif"
            >
              {{ $t("Save") }}
            </v-btn>
          </v-card-actions>
        </v-form>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import moment from "moment";
import { ColorPicker } from "vue-accessible-color-picker";
export default {
  components: {
    ColorPicker,
  },
  props: {
    x: {
      type: Number,
      required: true,
      default: 0,
    },
    y: {
      type: Number,
      required: true,
      default: 0,
    },
    name: {
      type: String,
      required: true,
      default: "",
    },
    path: {
      type: String,
      required: true,
      default: "",
    },
    id: {
      type: String,
      required: true,
      default: "",
    },
    accessTime: {
      type: String,
      required: true,
      default: "",
    },
    status: {
      type: String,
      required: true,
      default: "",
    },
    revision: {
      type: String,
      required: true,
      default: "",
    },
    length: {
      type: String,
      required: true,
      default: "",
    },
    description: {
      type: String,
      required: true,
      default: "",
    },
    language: {
      type: String,
      required: true,
      default: "",
    },
    sheet: {
      type: String,
      required: true,
      default: "",
    },
    document: {
      type: String,
      required: true,
      default: "",
    },
    isCheckFile: {
      type: Boolean,
      required: false,
    },
    checkTab: {
      type: Boolean,
      required: true,
    },
  },
  data() {
    return {
      selectedColor: "#bbdefb",
      // color: '',
      dialogFormChooseColor: false,
      excelData: null,
    };
  },
  methods: {
    formatDate() {
      let datetime = new Date();
      return "[" + moment(datetime).format("DD-MM-YYYY HH:mm:ss.SSS") + "]";
    },
    handlePreview() {
      console.log(this.formatDate(), "(MenuComponent) [handlePreview] name: ", this.name);
      console.log(this.formatDate(), "(MenuComponent) [handlePreview] path: ", this.path);
      if (!this.isCheckFile) {
        this.$emit("handlePreview", {
          fileName: this.name,
          filePath: this.path,
        });
      }
    },
    handleDownload() {
      console.log(
        this.formatDate(),
        "(MenuComponent) [handleDownload] name: ",
        this.name
      );
      console.log(
        this.formatDate(),
        "(MenuComponent) [handleDownload] path: ",
        this.path
      );
      if (!this.checkTab) {
        this.$emit("handleDownload", {
          fileName: this.name,
          filePath: this.path,
        });
      }
    },
    handleHighlight() {
      console.log(
        this.formatDate(),
        "(MenuComponent) [handleHighlight] name: ",
        this.name
      );
      console.log(
        this.formatDate(),
        "(MenuComponent) [handleHighlight] path: ",
        this.path
      );
      console.log(this.formatDate(), "(MenuComponent) [handleHighlight] id: ", this.id);
      this.$emit("handleHighlight", {
        fileName: this.name,
        filePath: this.path,
        fileId: this.id,
      });
    },
    handleHighlightColor() {
      console.log("(handleHighlightColor) Click success");
      this.dialogFormChooseColor = true;
      console.log(
        "(handleHighlightColor) this.dialogFormChooseColor: ",
        this.dialogFormChooseColor
      );
      console.log(
        "[handleHighlightColor] Color Save Change: ",
        this.$globalVariable.COLOR
      );
    },
    handleSaveList() {
      let resultPath = this.path.replace("E:\\Drive_W\\Data\\", "W:\\");
      if (!this.checkTab) {
        this.$emit(
          "handleSaveListEmit",
          {
            Name: this.name,
            Path: resultPath,
            AccessTime: this.accessTime,
            Status: this.status,
            Revision: this.revision,
            Length: this.length,
            Description: this.description,
            Language: this.language,
            Sheet: this.sheet,
            Document: this.document,
          },
          {
            name: this.name,
            path: this.path,
          }
        );
      }
    },
    updateColor(newColor) {
      console.log("[updateColor] newColor: ", newColor);
      this.selectedColor = newColor;
      console.log("[updateColor] This Color Change: ", this.selectedColor.colors.hex);
    },
    handleSaveChooseColor() {
      this.$emit("handleHighlightColorEmit", {
        color: this.selectedColor,
      });
      console.log("[handleSaveChooseColor] Color Save Change: ", this.selectedColor);
      this.dialogFormChooseColor = false;
    },
  },
};
</script>

<style scoped>
.custom-menu {
  z-index: 1000;
  position: fixed;
  overflow: hidden;
  white-space: nowrap;
  font-family: sans-serif;
  background: #fff;
  color: #333;
  border-radius: 5px;
  padding: 0px;
  margin: 0px;
  border: 1px solid #ccc;
}

/* Each of the items in the list */
.custom-menu ul {
  margin: 0;
  color: green;
  border: 0px solid red;
  padding-left: 0px;
  padding-top: 0px;
  width: 200px;
}

.custom-menu li {
  padding: 8px 22px;
  cursor: pointer;
  list-style-type: none;
  transition: all 0.3s ease;
  user-select: none;
  text-align: top;
}

.custom-menu li:hover {
  background-color: #87cefa;
}

.custom-menu li img {
  padding-right: 10px;
}

.icon-preview {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/preview_1.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.icon-download {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/download.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.icon-highlight {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/highlight.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.icon-highlight-color {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/color.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}
.icon-save-list {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/save-file.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.custom-menu-preview {
  display: flex;
  align-items: center;
}

.custom-menu-download {
  display: flex;
  align-items: center;
}

.custom-menu-highlight {
  display: flex;
  align-items: center;
}

.custom-menu-highlight-color {
  display: flex;
  align-items: center;
}
.custom-menu-save-list {
  display: flex;
  align-items: center;
}
.custom-menu-preview.disabled {
  cursor: not-allowed;
}
.custom-menu-download.disabled {
  cursor: not-allowed;
}
.custom-menu-save-list.disabled {
  cursor: not-allowed;
}
</style>
