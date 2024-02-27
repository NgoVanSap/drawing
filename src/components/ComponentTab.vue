<template>
  <div class="component_tab_class">
    <ComponentDropFiles
      v-if="isActiveComponentDropFiles"
      :listDropFiles="listDropFiles"
      :OptionButton="OptionButtonDropFiles"
      v-on:signalClose="handleCloseComponentDropFiles"
      v-on:signalCancel="handleCancelComponentDropFiles"
    ></ComponentDropFiles>
    <ComponentColumnConfiguration
      v-bind:isActiveComponent="isActiveComponentColumnConfiguration"
      v-on:signalClose="handleCloseComponentColumnConfiguration"
    ></ComponentColumnConfiguration>
    <ComponentFilterRows
      v-bind:isActiveComponent="isActiveComponentFilterRows"
      v-on:signalClose="handleCloseComponentFilterRows"
      v-on:signalOk="handleOkComponentFilterRows"
    ></ComponentFilterRows>
    <ComponentLoading
      v-bind:isActiveComponent="isActiveComponentRefresh"
    ></ComponentLoading>
    <div class="tab-container">
      <div
        class="tab tab_documents"
        :class="{ active: activeTab == this.$globalVariable.TAB_DOCUMENTS }"
        @click="activeTab = this.$globalVariable.TAB_DOCUMENTS"
      >
        {{ $t("Documents") }}
      </div>
      <div
        class="tab tab_images"
        :class="{ active: activeTab == this.$globalVariable.TAB_IMAGES }"
        @click="activeTab = this.$globalVariable.TAB_IMAGES"
      >
        {{ $t("Images") }}
      </div>
      <div
        class="tab tab_folders"
        :class="{ active: activeTab == this.$globalVariable.TAB_FOLDERS }"
        @click="activeTab = this.$globalVariable.TAB_FOLDERS"
      >
        {{ $t("Folders") }}
      </div>
      <div
        class="tab tab_rights_roles"
        :class="{ active: activeTab == this.$globalVariable.TAB_RIGHT_ROLES }"
        @click="activeTab = this.$globalVariable.TAB_RIGHT_ROLES"
      >
        {{ $t("RightsRoles") }}
      </div>
      <div
        class="tab tab_general"
        :class="{ active: activeTab == this.$globalVariable.TAB_GENERAL }"
        @click="activeTab = this.$globalVariable.TAB_GENERAL"
      >
        {{ $t("General") }}
      </div>
      <div
        class="tab tab_history"
        :class="{ active: activeTab == this.$globalVariable.TAB_HISTORY }"
        @click="activeTab = this.$globalVariable.TAB_HISTORY"
      >
        {{ $t("History") }}
      </div>
      <button
        v-if="this.$globalVariable.USER_INFO.admin == 1"
        class="button_drop_file hidden-column-s"
      >
        <i class="icon_button_drop_file"></i>{{ $t("DropFiles") }}
      </button>
    </div>
    <div class="tab-summary">
      <div class="information">
        <div v-if="this.isActiveInformation" class="sum_file">
          {{ this.$globalVariable.TITLE_NUMBER_OF_FILE }} : {{ this.Number_of_Documents }}
        </div>
        <div
          v-if="this.isActiveInformation && this.isActiveTableFolder == false"
          class="sum_size"
        >
          {{ $t("TotalSize") }}: {{ this.sizeAllFiles }}
        </div>
      </div>

      <div class="option">
        <div class="simple-view">
          <button @click="HandleSimpleView" class="button-simple-view">
            <i v-if="isViewListLayout" class="icon-simple-view-list"></i
            ><i v-if="!isViewListLayout" class="icon-simple-view-grid"></i
            >{{ this.$globalVariable.TEXT_LAYOUT }}
          </button>
        </div>
        <div class="column-configuration hidden-column-vs">
          <button @click="HandleColumnConfiguration" class="button-column-configuration">
            <i class="icon-column-configuration"></i>{{ $t("ColumnConfiguration") }}
          </button>
        </div>
        <div class="filter-rows hidden-column-s">
          <button @click="HandleFilterRows" class="button-filter-rows">
            <i class="icon-filter-rows"></i>{{ $t("FilterRows") }}
          </button>
        </div>
        <div class="refresh-list hidden-column-s">
          <button @click="HandleRefreshList" class="button-refresh-list">
            <i class="icon-refresh-list"></i>{{ $t("Refresh") }}
          </button>
        </div>
      </div>
    </div>

    <div
      class="tab-table"
      ref="myTable123"
      @mousemove="handleMouseMove"
      :class="{ dragging: this.isDragging }"
      @drop.prevent="handleDropFile"
      @dragover.prevent="handleDragover"
      @dragleave="handleDragLeave"
    >
      <!-- View Grid Layout -->
      <div v-if="!isViewListLayout" class="file-grid">
        <ComponentGridLayout
          v-for="file in listFiles"
          :key="file.id"
          :file="file"
          :menuVisible="menuVisibleGridLayout"
          v-on:signal_show_menu="handleGridShowMenu"
        ></ComponentGridLayout>
      </div>
      <!-- View List Layout -->
      <table v-if="this.isActiveTableFiles && this.isViewListLayout" class="custom-table">
        <thead>
          <tr>
            <th class="fix-header th-no">
              <input type="checkbox" @change="selectAllRows" />
            </th>
            <th class="fix-header th-title">{{ $t("Title") }}</th>
            <th
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.author"
              class="fix-header hidden-column-s th-author"
            >
              {{ $t("Author") }}
            </th>
            <th
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.last_check_in"
              class="fix-header hidden-column-s th-last_checkin"
            >
              {{ $t("DateAccessed") }}
            </th>
            <th
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.status"
              class="fix-header hidden-column-s th-status"
            >
              {{ $t("Status") }}
            </th>
            <th
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.revision"
              class="fix-header hidden-column-s th-version"
            >
              {{ $t("Revision") }}
            </th>
            <th
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.size"
              class="fix-header hidden-column-s th-size"
            >
              {{ $t("Size") }}
            </th>
            <th
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.autom_rev"
              class="fix-header hidden-column-s hidden-column-m th-auto_rev"
            >
              {{ $t("AutomRev") }}
            </th>
            <th
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.description"
              class="fix-header hidden-column-s hidden-column-m th-desciption"
            >
              {{ $t("Description") }}
            </th>
            <th
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.language"
              class="fix-header hidden-column-s hidden-column-m th-language"
            >
              {{ $t("Language") }}
            </th>
            <th
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.sheet"
              class="fix-header hidden-column-s hidden-column-m th-sheet"
            >
              {{ $t("Sheet") }}
            </th>
            <th
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.document_number"
              class="fix-header hidden-column-s hidden-column-m th-document"
            >
              {{ $t("DocumentNumber") }}
            </th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(file, index) in isCheckOldFile ? vualueSearch : listFiles"
            :key="file.id"
          >
            <td class="td-no"><input type="checkbox" @change="selectRows(file.id)" /></td>
            <td
              class="td-title"
              @mouseover="showCellContentTitle($event, index)"
              @mouseout="hideCellContentTitle($event, index)"
            >
              <div class="cell-content">
                <div class="icon-title">
                  <div class="icon-file">
                    <i :class="getFileIconClass(file.Extension)"></i>
                  </div>
                  <a
                    class="td-title-a"
                    href="#"
                    :id="file.FullName"
                    target="_blank"
                    @click.left="handleLeftClick"
                    @click.right="handleRightClick($event, file.FullName)"
                    @mouseover="showCellContent($event, file.FullName)"
                    @mouseout="hideCellContent"
                    @contextmenu="
                      showMenu(
                        $event,
                        file.id,
                        file.Name,
                        file.FullName,
                        file.LastAccessTime,
                        file.Status,
                        file.Revision,
                        file.Length,
                        file.Description,
                        file.Language,
                        file.Sheet,
                        file.DocumentNumber
                      )
                    "
                    v-html="highlightText(file.Name)"
                  >
                  </a>
                </div>

                <div class="bookmark">
                  <label class="star-checkbox">
                    <input
                      type="checkbox"
                      id="checkbox-bookmark"
                      v-model="isCheckedRowBookmark[index]"
                      @click="onClickRowBookmark(file.Name, file.FullName, index)"
                    />
                    <span
                      v-if="!isCheckedRowBookmark[index]"
                      class="unchecked-star"
                      :class="{ hover: isMouseOverRowTitle[index] }"
                    ></span>
                    <span v-if="isCheckedRowBookmark[index]" class="checked-star"></span>
                  </label>
                </div>
                <menu-component
                  v-if="menuVisible"
                  :x="menuX"
                  :y="isHeight"
                  :name="fileNameSelected"
                  :id="fileId"
                  :path="filePathSelected"
                  :accessTime="lastAccessTime"
                  :status="status"
                  :revision="revision"
                  :length="length"
                  :description="description"
                  :language="language"
                  :sheet="sheet"
                  :document="documentNumber"
                  :isCheckFile="isCheckFile"
                  :checkTab="checkTab"
                  v-on:handlePreview="handlePreview"
                  v-on:handleDownload="handleDownload"
                  v-on:handleHighlight="handleHighlight"
                  v-on:handleSaveListEmit="handleSaveListEmit"
                  @handleHighlightColorEmit="handleHighlightColorEmit"
                  v-on:ChooseColorCloseMenu="ChooseColorCloseMenu"
                ></menu-component>
                <popup-hover-file
                  v-if="showContent"
                  :x="popupX"
                  :y="popupY"
                  :name="pathFileHover"
                ></popup-hover-file>
              </div>
            </td>
            <td
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.author"
              class="td-author hidden-column-s"
            ></td>
            <td
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.last_check_in"
              class="td-last_checkin hidden-column-s"
            >
              {{ file.LastAccessTime }}
            </td>
            <!--<td v-if="this.$globalVariable.COLUMN_CONFIGURATION.status" class="td-status hidden-column-s">
                        <div class="circle" :class="{ 'error':file.IsReadOnly}"></div>
                    </td>-->
            <td
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.status"
              class="td-status hidden-column-s"
            >
              {{ file.Status }}
            </td>
            <td
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.revision"
              class="td-version hidden-column-s"
            >
              {{ file.Revision }}
            </td>
            <td
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.size"
              class="td-size hidden-column-s"
            >
              {{ file.Length }}
            </td>
            <td
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.autom_rev"
              class="td-auto_rev hidden-column-s hidden-column-m"
            ></td>
            <td
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.description"
              class="td-description hidden-column-s hidden-column-m"
              v-html="highlightText(file.Description)"
            ></td>
            <td
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.language"
              class="td-version hidden-column-s hidden-column-m"
            >
              {{ file.Language }}
            </td>
            <td
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.sheet"
              class="td-version hidden-column-s hidden-column-m"
            >
              {{ file.Sheet }}
            </td>
            <td
              v-if="this.$globalVariable.COLUMN_CONFIGURATION.document_number"
              class="td-description hidden-column-s hidden-column-m"
              v-html="highlightText(file.DocumentNumber)"
            ></td>
          </tr>
        </tbody>
      </table>

      <!-- This is table to show data Right and Roles -->
      <table v-if="this.isActiveTableRightAndRoles" class="custom-table">
        <thead>
          <tr>
            <th class="fix-header th_rightandroles_no">{{ $t("No") }}</th>
            <th class="fix-header th_rightandroles_username">{{ $t("Username") }}</th>
            <th class="fix-header th_rightandroles_fullControl">
              {{ $t("FullControl") }}
            </th>
            <th class="fix-header th_rightandroles_modify">{{ $t("Modify") }}</th>
            <th class="fix-header th_rightandroles_readAndExecute">
              {{ $t("ReadExecute") }}
            </th>
            <th class="fix-header th_rightandroles_write">{{ $t("Write") }}</th>
            <th class="fix-header th_rightandroles_synchronize">
              {{ $t("Synchronize") }}
            </th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(itemData, index) in listRightAndRoles" :key="itemData.id">
            <td class="td_rightandroles_no">{{ itemData.id }}</td>
            <td class="td_rightandroles_username">
              <div class="data_rightandroles_username">{{ itemData.Username }}</div>
            </td>
            <td class="td_rightandroles_fullControl">
              <input
                type="checkbox"
                class="form-check-input"
                id="flexSwitchCheckDefault"
                :checked="isCheckRightandRoles_fullControl[index]"
                disabled
              />
            </td>
            <td class="td_rightandroles_modify">
              <input
                type="checkbox"
                class="form-check-input"
                id="flexSwitchCheckDefault"
                :checked="isCheckRightandRoles_modify[index]"
                disabled
              />
            </td>
            <td class="td_rightandroles_readAndExecute">
              <input
                type="checkbox"
                class="form-check-input"
                id="flexSwitchCheckDefault"
                :checked="isCheckRightandRoles_readAndExecute[index]"
                disabled
              />
            </td>
            <td class="td_rightandroles_write">
              <input
                type="checkbox"
                class="form-check-input"
                id="flexSwitchCheckDefault"
                :checked="isCheckRightandRoles_write[index]"
                disabled
              />
            </td>
            <td class="td_rightandroles_synchronize">
              <input
                type="checkbox"
                class="form-check-input"
                id="flexSwitchCheckDefault"
                :checked="isCheckRightandRoles_synchronize[index]"
                disabled
              />
            </td>
          </tr>
        </tbody>
      </table>

      <div v-if="this.isActiveTableGeneral" class="container_tab_general">
        <div class="tab_general_name">
          <div class="tab_general_name_title">{{ $t("Name") }}:</div>
          <div class="tab_general_name_value">
            {{ this.$globalVariable.GENERAL_DIRECTORY.name }}
          </div>
        </div>
        <div class="tab_general_name">
          <div class="tab_general_name_title">{{ $t("FullName") }}:</div>
          <div class="tab_general_name_value">
            {{ this.$globalVariable.GENERAL_DIRECTORY.fullname }}
          </div>
        </div>
        <div class="tab_general_name">
          <div class="tab_general_name_title">{{ $t("Type") }}:</div>
          <div class="tab_general_name_value">
            {{ this.$globalVariable.GENERAL_DIRECTORY.type }}
          </div>
        </div>
        <div class="tab_general_name">
          <div class="tab_general_name_title">{{ $t("Location") }}:</div>
          <div class="tab_general_name_value">
            {{ this.$globalVariable.GENERAL_DIRECTORY.location }}
          </div>
        </div>
        <!-- <div class="tab_general_name">
                <div class="tab_general_name_title">{{ $t('Size') }}:</div>
                <div class="tab_general_name_value">{{ this.$globalVariable.GENERAL_DIRECTORY.length }} ({{ this.$globalVariable.GENERAL_DIRECTORY.size }})</div>
            </div> -->
        <div class="tab_general_name">
          <div class="tab_general_name_title">{{ $t("Contains") }}:</div>
          <div class="tab_general_name_value">
            {{ this.$globalVariable.GENERAL_DIRECTORY.files }} {{ $t("Files") }},
            {{ this.$globalVariable.GENERAL_DIRECTORY.directories }} {{ $t("Folders") }}
          </div>
        </div>
        <div class="tab_general_name">
          <div class="tab_general_name_title">{{ $t("DateCreated") }}:</div>
          <div class="tab_general_name_value">
            {{ this.$globalVariable.GENERAL_DIRECTORY.creationTime }}
          </div>
        </div>
        <div class="tab_general_name">
          <div class="tab_general_name_title">{{ $t("DateAccessed") }}:</div>
          <div class="tab_general_name_value">
            {{ this.$globalVariable.GENERAL_DIRECTORY.lastAccessTime }}
          </div>
        </div>
      </div>

      <!-- This is table to show data History -->
      <table v-if="this.isActiveTabHistory" class="custom-table">
        <thead>
          <tr>
            <th class="fix-header th_history_no">{{ $t("No") }}</th>
            <th class="fix-header th_history_filename">{{ $t("FileName") }}</th>
            <th class="fix-header th_history_filepath">{{ $t("FilePath") }}</th>
            <th class="fix-header th_history_date_accessed">{{ $t("DateAccessed") }}</th>
            <th class="fix-header th_history_action">{{ $t("Action") }}</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="itemData in listHistory" :key="itemData.id">
            <td class="td_history_no">{{ itemData.id }}</td>
            <td class="td_history_filename">
              <div class="data_history_filename">{{ itemData.file_name }}</div>
            </td>
            <td class="td_history_filepath">
              <div class="data_history_filepath">{{ itemData.file_path }}</div>
            </td>
            <td class="td_history_date_accessed">{{ itemData.date_accessed }}</td>
            <td class="td_history_action">
              {{ $t(`actions.${itemData.action}`) }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import moment from "moment";
import axios from "axios";
import { saveAs } from "file-saver";
import MenuComponent from "./MenuComponent.vue";
import PopupHoverFile from "./PopupHoverFile.vue";
import ComponentDropFiles from "./ComponentDropFiles.vue";
import ComponentColumnConfiguration from "./ComponentColumnConfiguration.vue";
import ComponentFilterRows from "./ComponentFilterRows.vue";
import ComponentLoading from "./ComponentLoading.vue";
import ComponentGridLayout from "./ComponentGridLayout.vue";
export default {
  components: {
    MenuComponent,
    PopupHoverFile,
    ComponentDropFiles,
    ComponentColumnConfiguration,
    ComponentFilterRows,
    ComponentLoading,
    ComponentGridLayout,
  },
  props: {
    listFiles: {
      type: Array,
      required: true,
    },
    listRightAndRoles: {
      type: Array,
      required: true,
    },
    isCheckRightandRoles_fullControl: {
      type: Array,
      required: true,
    },
    isCheckRightandRoles_modify: {
      type: Array,
      required: true,
    },
    isCheckRightandRoles_readAndExecute: {
      type: Array,
      required: true,
    },
    isCheckRightandRoles_write: {
      type: Array,
      required: true,
    },
    isCheckRightandRoles_synchronize: {
      type: Array,
      required: true,
    },
    sizeAllFiles: {
      type: String,
      required: true,
      default: "0 byte",
    },
    menuVisible: {
      type: Boolean,
      required: true,
      default: false,
    },
    currentPath: {
      type: String,
      required: true,
      default: "",
    },
    oldListFiles: {
      type: Array,
      required: null,
    },
    checkTab: {
      type: Boolean,
      required: true,
    },
  },
  data() {
    return {
      isCheckOldFile: false,
      activeTab: "tab_documents",
      selectedRows: false,
      selectAll: [],
      listHistory: [],
      Number_of_Documents: 0,
      menuX: 0,
      menuY: 0,
      popupX: 0,
      popupY: 0,
      fileId: "",
      fileNameSelected: "",
      filePathSelected: "",
      lastAccessTime: "",
      status: "",
      revision: "",
      length: "",
      description: "",
      language: "",
      sheet: "",
      documentNumber: "",
      showContent: false,
      pathFileHover: "",
      isActiveTableRightAndRoles: false,
      isActiveInformation: true,
      isActiveTableFolder: false,
      isActiveTableFiles: true,
      isActiveTableGeneral: false,
      isActiveTabHistory: false,
      progressPercent: 0,
      isDragging: false,
      isActiveComponentDropFiles: false,
      isActiveComponentColumnConfiguration: false,
      isActiveComponentFilterRows: false,
      isActiveComponentRefresh: false,
      listDropFiles: [],
      OptionButtonDropFiles: "Cancel",
      isViewListLayout: true,
      textViewLayout: "List layout",
      menuVisibleGridLayout: false,
      isMouseOverRowTitle: [],
      isCheckedRowBookmark: [],
      isCheckFile: false,
      isCheckClientY: false,
      isHeight: 0,
    };
  },
  methods: {
    formatDate() {
      let datetime = new Date();
      return "[" + moment(datetime).format("DD-MM-YYYY HH:mm:ss.SSS") + "]";
    },
    async onClickRowBookmark(Name, FullName, index) {
      const status = !this.isCheckedRowBookmark[index];
      console.log(
        "[onClickRowBookmark] Name: ",
        Name,
        "and FullName: ",
        FullName,
        "isChecked: ",
        status
      );
      const jsonData = {
        user_id: this.$globalVariable.USER_INFO.userID,
        name: Name,
        location: FullName,
        type: 1,
        is_delete: !status,
      };

      const jsonString = JSON.stringify(jsonData);
      console.log("(onClickRowBookmark) jsonString: ", jsonString);
      await axios
        .post(this.$globalVariable.URL_API + "/Option/update_favorites/", jsonString, {
          headers: {
            "Content-Type": "application/json",
          },
        })
        .then((response) => {
          console.log("(onClickRowBookmark) response: ", response.data);
          if (this.$globalVariable.PAGE_CURRENT == "favorites") {
            this.$emit("signal_remove_file_bookmark", index);
          }
        })
        .catch((error) => {
          console.error("(onClickRowBookmark) error: ", error);
        });
    },
    showCellContentTitle(event, index) {
      // This is event Mouse over on the item

      this.isMouseOverRowTitle[index] = true;
      event.preventDefault();
    },
    hideCellContentTitle(event, index) {
      // This is event Mouse out of the item
      this.isMouseOverRowTitle[index] = false;
      event.preventDefault();
    },
    handleGridShowMenu(params) {
      console.log("[GridLayout] handleGridShowMenu");
      const { fileNameSelected, filePathSelected, menuX, menuY } = params;

      this.fileNameSelected = fileNameSelected;
      this.filePathSelected = filePathSelected;
      this.menuX = menuX;
      this.menuY = menuY;

      this.$emit("signal_show_menu_grid_layout");
    },
    handleOkComponentFilterRows() {
      console.log("[handleOkComponentFilterRows] list File: ", this.listFiles);
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] (componentTab) slot handle Ok"
      );
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] title_value: ",
        this.$globalVariable.FILTER_ROWS.title_value
      );
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] title_option: ",
        this.$globalVariable.FILTER_ROWS.title_option
      );
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] last_check_in_day: ",
        this.$globalVariable.FILTER_ROWS.last_check_in_day
      );
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] last_check_in_month: ",
        this.$globalVariable.FILTER_ROWS.last_check_in_month
      );
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] last_check_in_year: ",
        this.$globalVariable.FILTER_ROWS.last_check_in_year
      );
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] author: ",
        this.$globalVariable.FILTER_ROWS.author
      );
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] status: ",
        this.$globalVariable.FILTER_ROWS.status
      );
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] version: ",
        this.$globalVariable.FILTER_ROWS.version
      );
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] size_from_value: ",
        this.$globalVariable.FILTER_ROWS.size_from_value
      );
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] size_from_option: ",
        this.$globalVariable.FILTER_ROWS.size_from_option
      );
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] size_to_value: ",
        this.$globalVariable.FILTER_ROWS.size_to_value
      );
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] size_to_option: ",
        this.$globalVariable.FILTER_ROWS.size_to_option
      );
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] autom_rev: ",
        this.$globalVariable.FILTER_ROWS.autom_rev
      );
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] description: ",
        this.$globalVariable.FILTER_ROWS.description
      );
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] tab current: ",
        this.$globalVariable.TAB_CURRENT
      );
      this.isActiveComponentFilterRows = false;
      this.$globalVariable.FILTER_ROWS.is_active = true;
      this.$emit("signalReloadDataByFilterRows");
    },
    handleCloseComponentFilterRows() {
      console.log("[ComponentFilterRows] slot handle close");
      this.isActiveComponentFilterRows = false;
      this.$globalVariable.FILTER_ROWS.is_active = false;
      this.$emit("signalReloadDataByFilterRows");
    },
    handleCloseComponentColumnConfiguration() {
      this.isActiveComponentColumnConfiguration = false;
      console.log(
        "[column_configuration] (reload) author: ",
        this.$globalVariable.COLUMN_CONFIGURATION.author
      );
      console.log(
        "[column_configuration] (reload) last_check_in: ",
        this.$globalVariable.COLUMN_CONFIGURATION.last_check_in
      );
      console.log(
        "[column_configuration] (reload) status: ",
        this.$globalVariable.COLUMN_CONFIGURATION.status
      );
      console.log(
        "[column_configuration] (reload) rersion: ",
        this.$globalVariable.COLUMN_CONFIGURATION.revision
      );
      console.log(
        "[column_configuration] (reload) size: ",
        this.$globalVariable.COLUMN_CONFIGURATION.size
      );
      console.log(
        "[column_configuration] (reload) autom_rev: ",
        this.$globalVariable.COLUMN_CONFIGURATION.autom_rev
      );
      console.log(
        "[column_configuration] (reload) description: ",
        this.$globalVariable.COLUMN_CONFIGURATION.description
      );
    },
    handleCancelComponentDropFiles() {
      let isClose = 0;
      for (let i = 0; i < this.listDropFiles.length; i++) {
        if (this.listDropFiles[i].isRunning == false) {
          this.listDropFiles[i].isCancel = true;
        }
        if (this.listDropFiles[i].isCancel || this.listDropFiles[i].isFinished) {
          isClose++;
        }
      }
      if (isClose == this.listDropFiles.length) {
        this.isActiveComponentDropFiles = false;
        this.OptionButtonDropFiles = "Cancel";
      }
    },
    handleCloseComponentDropFiles() {
      for (let i = 0; i < this.listDropFiles.length; i++) {
        if (this.listDropFiles[i].isRunning == false) {
          this.listDropFiles[i].isCancel = true;
        }
      }
      this.isActiveComponentDropFiles = false;
      this.OptionButtonDropFiles = "Cancel";
    },
    handleDragLeave(event) {
      event.preventDefault();
      this.isDragging = false;
    },
    handleDragover(event) {
      event.preventDefault();
      if (this.$globalVariable.USER_INFO.admin == 1) {
        this.isDragging = true;
      }
    },
    async handleDropFile(event) {
      if (this.$globalVariable.USER_INFO.admin == 1) {
        console.log("[handleDropFile] begin");
        console.log("[handleDropFile] Dir current: ", this.$globalVariable.DIR_SELECTED);

        this.OptionButtonDropFiles = "Cancel";
        let isRoot = false;
        if (this.$globalVariable.DIR_SELECTED == "/") {
          isRoot = true;
        }
        console.log("[handleDropFile] isRoot: ", isRoot);

        event.preventDefault();
        this.isDragging = false;
        this.isActiveComponentDropFiles = true;
        this.listDropFiles = [];

        const files = event.dataTransfer.files;
        for (let i = 0; i < files.length; i++) {
          var item = {
            id: i + 1,
            fileName: files[i].name,
            fileSize: files[i].size,
            uploadPercent: 0,
            isFinished: false,
            isCancel: isRoot,
            isResult: "waiting",
            isRunning: false,
          };
          this.listDropFiles.push(item);
        }

        console.log("[handleDropFile] files: ", files);
        console.log("[handleDropFile] files: ", files.length);
        for (let i = 0; i < files.length; i++) {
          console.log("[handleDropFile] name: ", files[i].name);
          console.log("[handleDropFile] size: ", files[i].size, "bytes");
          if (this.listDropFiles[i].isCancel == false) {
            this.listDropFiles[i].isRunning = true;
            await this.uploadFileDrop(files[i], i);
            setTimeout(() => {
              this.listDropFiles[i].isFinished = true;
            }, 500);
          }
        }
        console.log("[handleDropFile] completed");
        this.OptionButtonDropFiles = "Close";
        this.$emit("signalReloadDataAfterDropFiles");
      }
    },
    async uploadFileDrop(file, index) {
      const filePath = this.$globalVariable.DIR_SELECTED + "\\" + file.name;
      const formData = new FormData();
      formData.append("file", file);
      formData.append("filePath", filePath);
      await axios
        .post(this.$globalVariable.URL_API + "/Files/drop_files/", formData, {
          headers: {
            "Content-Type": "multipart/form-data",
          },
          onUploadProgress: (ProgressEvent) => {
            this.progressPercent = Math.round(
              (ProgressEvent.loaded / ProgressEvent.total) * 100
            );
            console.log(
              "[handleDropFile] progressPercent[",
              index,
              "]: ",
              this.progressPercent
            );
            this.listDropFiles[index].uploadPercent = this.progressPercent;
          },
        })
        .then((response) => {
          this.listDropFiles[index].isResult = "success";
          console.log("[handleDropFile] response: ", response.data);
        })
        .catch((error) => {
          this.listDropFiles[index].isResult = "error";
          console.error("[handleDropFile] error: ", error);
        })
        .finally(() => {
          console.log("[handleDropFile] finally");
        });
    },
    async HandleRefreshList() {
      console.log("[HandleRefreshList] componentTab");
      this.$globalVariable.DATA_RESPONSE_REFRESH = "";
      this.$globalVariable.FILTER_ROWS.is_active = false;
      this.isActiveComponentRefresh = true;
      await this.processRefreshList();
      await this.$emit("signalReloadDataByRefresh");
      this.isActiveComponentRefresh = false;
    },
    async processRefreshList() {
      const jsonData = {
        id: 0,
        name: "",
        path: this.currentPath,
        user_id: this.$globalVariable.USER_INFO.userID,
      };

      const jsonString = JSON.stringify(jsonData);
      console.log("[HandleRefreshList] jsonString:", jsonString);

      await axios
        .post(this.$globalVariable.URL_API + "/Option/load_refresh", jsonString, {
          headers: {
            "Content-Type": "application/json",
          },
        })
        .then((response) => {
          console.log("[HandleRefreshList] response:", response.data);
          this.$globalVariable.DATA_RESPONSE_REFRESH = response.data;
        })
        .catch((error) => {
          console.error("[HandleRefreshList] error:", error);
        });
    },
    HandleFilterRows() {
      this.isActiveComponentFilterRows = true;
      console.log("[handleOkComponentFilterRows] List File: ", this.listFiles);
    },
    HandleColumnConfiguration() {
      this.isActiveComponentColumnConfiguration = true;
    },
    HandleSimpleView() {
      this.isViewListLayout = !this.isViewListLayout;
      this.$emit("isViewListLayout", this.isViewListLayout);
    },
    highlightText(text) {
      if (this.$globalVariable.SEARCH_TEXT) {
        const regex = new RegExp(this.$globalVariable.SEARCH_TEXT, "gi");
        // console.log("(highlightText)");
        const text_tmp = text.replace(
          regex,
          (match) => `<span style="background-color: yellow;">${match}</span>`
        );
        return text_tmp;
      }
      return text;
    },
    showCellContent(event, fullName) {
      if (
        fullName.includes(".pdf") ||
        fullName.includes(".png") ||
        fullName.includes(".jpg")
      ) {
        this.isCheckFile = false;
      } else {
        this.isCheckFile = true;
      }
      console.log("[showCellContent]  this.isCheckFile: ", this.isCheckFile);
      this.fileId = fullName;
      // const element = this.$refs.myTable123;
      // const elementRect = element.getBoundingClientRect();
      // const mouseY = event.clientY;
      // const isNearBottom = mouseY >= elementRect.bottom - 160;
      this.pathFileHover = fullName
        .replace("/Data/Data/", "")
        .replace("E:\\Drive_W\\Data\\", "")
        .replace("W:\\", "");
      this.popupX = event.clientX;
      this.popupY = event.clientY;
      // this.menuX = event.clientX;
      // this.isHeight = !isNearBottom ? event.clientY : event.clientY - 201;
      this.showContent = true;
    },

    hideCellContent() {
      // console.log('hideCellContent');
      this.showContent = false;
    },
    handlePreview(params) {
      const { fileName, filePath } = params;
      console.log("(ComponentTab) [handlePreview] fileName: ", fileName);
      console.log("(ComponentTab) [handlePreview] filePath: ", filePath);
      let filePathNew = filePath;
      // if (this.$globalVariable.RUNNING_DOCKER) {
      //     filePathNew = filePathNew.replace('W:\\', '/Data/Data/');
      //     filePathNew = filePathNew.replace("\\", "/");
      // } else {
      //     filePathNew = filePathNew.replace('W:\\', this.$globalVariable.DIR_DATA_E);
      // }
      console.log("(ComponentTab) [handlePreview] filePathNew: ", filePathNew);
      if (fileName.includes(".pdf")) {
        console.log("this is file pdf: ", filePathNew);
        this.handleOpenFilePDF(fileName, filePathNew);
      } else if (fileName.includes(".dwg")) {
        console.log("this is file dwg: ", filePathNew);
        this.handleOpenFileDWGV1(fileName, filePathNew);
      } else if (fileName.includes(".xlsx")) {
        this.handleOpenFileExcel(fileName, filePathNew);
        console.log("this is file xlsx: ", filePathNew);
      } else if (fileName.includes(".png") || fileName.includes(".jpg")) {
        this.handleOpenImg(fileName, filePathNew);
        console.log("this is file png: ", filePathNew);
      }
      this.$emit("signal_close_menu");
    },
    handleDownload(params) {
      const { fileName, filePath } = params;
      console.log("(ComponentTab) [handleDownload] fileName: ", fileName);
      console.log("(ComponentTab) [handleDownload] filePath: ", filePath);
      var filePathNew = filePath;
      // if (this.$globalVariable.RUNNING_DOCKER) {
      //     filePathNew = filePathNew.replace('W:\\', '/Data/Data/')
      //     filePathNew = filePathNew.replace("\\", "/");
      // } else {
      //     filePathNew = filePathNew.replace('W:\\', this.$globalVariable.DIR_DATA_E)
      // }
      console.log("(ComponentTab) [handleDownload] filePathNew: ", filePathNew);
      if (fileName.includes(".pdf")) {
        console.log("this is file pdf: ", filePathNew);
        this.handleDownloadFilePDF(fileName, filePathNew);
      } else if (fileName.includes(".dwg")) {
        console.log("this is file dwg: ", filePathNew);
        this.handleDownloadFilePWG(fileName, filePathNew);
      } else if (fileName.includes(".xlsx")) {
        console.log("this is file excel: ", filePathNew);
        this.handleDownloadFileExcel(fileName, filePathNew);
      } else if (fileName.includes(".docx")) {
        console.log("this is file docx: ", filePathNew);
        this.handleDownloadFileDocs(fileName, filePathNew);
      } else if (fileName.includes(".pptx")) {
        console.log("this is file pptx: ", filePathNew);
        this.handleDownloadFilePower(fileName, filePathNew);
      } else if (fileName.includes(".png")) {
        console.log("this is file png: ", filePathNew);
        this.handleDownloadFilePng(fileName, filePathNew);
      } else {
        console.log("unknown type");
      }
      this.$emit("signal_close_menu");
    },
    handleHighlight(params) {
      console.log("(handleHighlight) Params Highlight: ", params);
      this.$emit("handleHighlightFromTab", params);
      this.$emit("signal_close_menu");
    },
    handleHighlightColorEmit(value) {
      console.log(
        "(handleHighlightColorEmit) $Emit color Components Menu: ",
        value.color.colors.hex
      );
      this.$emit("handleChooseColor", value);
      this.$globalVariable.COLOR = value.color.colors.hex;
      console.log(
        "(handleHighlightColorEmit) $globalVariable.COLOR: ",
        this.$globalVariable.COLOR
      );
    },
    handleSaveListEmit(params, data) {
      console.log("[handleSaveListEmit] Params: ", params);
      console.log("[handleSaveListEmit] Data: ", data);
      this.$emit("signalHandleSaveList", params, data);
      this.$emit("signal_close_menu");
    },
    ChooseColorCloseMenu() {
      this.$emit("signal_close_menu");
    },

    showMenu(
      event,
      id,
      name,
      path,
      lastAccessTime,
      status,
      revision,
      length,
      description,
      language,
      sheet,
      document_number
    ) {
      console.log("[showMenu] path: ", path);
      this.fileNameSelected = name;
      this.filePathSelected = path;
      this.lastAccessTime = lastAccessTime;
      this.status = status;
      this.revision = revision;
      this.length = length;
      this.description = description;
      this.language = language;
      this.sheet = sheet;
      this.documentNumber = document_number;
      this.menuX = event.clientX;
      if (!this.isCheckClientY) {
        this.menuY = event.clientY;
      }
      this.showContent = false;
      event.preventDefault();
      this.$emit("signal_show_menu");
    },
    handleLeftClick(event) {
      event.preventDefault();
      console.log("Click left: ", event.target);
    },
    handleRightClick(event, name) {
      if (name.includes(".pdf") || name.includes(".png") || name.includes(".jpg")) {
        this.isCheckFile = false;
      } else {
        this.isCheckFile = true;
      }
      // console.log("[handleRightClick] isCheckFile: ", this.isCheckFile);
      const element = this.$refs.myTable123;
      const elementRect = element.getBoundingClientRect();
      const mouseY = event.clientY;
      const isNearBottom = mouseY >= elementRect.bottom - 160;
      this.menuX = event.clientX;
      this.isHeight = !isNearBottom ? event.clientY : event.clientY - 201;
    },
    selectAllRows() {
      console.log("selectAllRows");
    },
    selectRows(id) {
      console.log("selectRows: ", id);
    },
    getFileIconClass(extension) {
      var value = extension.toLowerCase();
      switch (value) {
        case ".pdf":
          return "icon_pdf";
        case ".dwg":
          return "icon_dwg";
        case ".doc":
        case ".docx":
          return "icon_word";
        case ".xls":
        case ".xlsx":
          return "icon_excel";
        case ".ppt":
        case ".pptx":
          return "icon_powerpoint";
        case ".jpg":
        case ".jpeg":
        case ".png":
          return "icon_image";
        case ".rar":
        case ".zip":
          return "icon_winrar";
        case ".directory":
          return "icon_directory";
        default:
          return "icon_file";
      }
    },
    handleOpenFilePDF(fileName, path) {
      console.log("Click Open File PDF: ", fileName, "and path: ", path);
      const jsonData = {
        userID: this.$globalVariable.USER_INFO.userID,
        name: fileName,
        path: path,
      };

      const jsonString = JSON.stringify(jsonData);
      console.log("jsonData: ", jsonData);
      console.log("jsonString: ", jsonString);
      axios
        .post(
          this.$globalVariable.URL_API + "/WeatherForecast/open_file_pdf",
          jsonString,
          {
            headers: {
              "Content-Type": "application/json",
            },
            responseType: "blob",
          }
        )
        .then((response) => {
          console.log(response.data);
          console.log("(OpenPDF) Response Data: ", response);
          const file = new Blob([response.data], {
            type: "application/pdf",
          });
          const fileURL = URL.createObjectURL(file);
          const newTab = window.open(fileURL, "_blank");
          newTab.location.href = fileName;
          newTab.onload = function () {
            newTab.document.write(`<html><head><title>${fileName}</title></head></html>`);
            newTab.document.body.innerHTML = `<embed src="${fileURL}" type="application/pdf" width="100%"" height="100%" />`;
            newTab.document.close();
          };
        })
        .catch((error) => {
          console.error(error);
        });
    },
    handleDownloadFilePDF(fileName, path) {
      console.log("Click Download File PDF: ", fileName, "and path: ", path);
      const jsonData = {
        userID: this.$globalVariable.USER_INFO.userID,
        name: fileName,
        path: path,
      };

      const jsonString = JSON.stringify(jsonData);
      console.log("(handleDownloadFilePDF) jsonData: ", jsonData);
      console.log("(handleDownloadFilePDF) jsonString: ", jsonString);
      axios
        .post(
          this.$globalVariable.URL_API + "/WeatherForecast/download_file_pdf/",
          jsonString,
          {
            headers: {
              "Content-Type": "application/json",
            },
            responseType: "blob",
          }
        )
        .then((response) => {
          console.log(response.data);
          const file = new Blob([response.data], {
            type: "application/pdf",
          });
          const fileURL = URL.createObjectURL(file);
          const link = document.createElement("a");
          link.href = fileURL;
          link.download = `${fileName}`;
          const clickEvent = new MouseEvent("click");
          link.dispatchEvent(clickEvent);
          URL.revokeObjectURL(fileURL);
        })
        .catch((error) => {
          console.error(error);
        });
    },
    handleOpenImg(fileName, path) {
      console.log("[handleOpenImg] fileName: ", fileName);
      console.log("[handleOpenImg] path: ", path);

      const jsonData = {
        userID: this.$globalVariable.USER_INFO.userID,
        name: fileName,
        path: path,
      };
      const jsonString = JSON.stringify(jsonData);
      console.log("[handleOpenImg] Json Data: ", jsonData);
      console.log("[handleOpenImg] Json String: ", jsonString);
      axios
        .post(this.$globalVariable.URL_API + "/WeatherForecast/open_img/", jsonString, {
          headers: {
            "Content-Type": "application/json",
            Accept: "image/jpeg",
          },
          responseType: "arraybuffer",
        })
        .then((response) => {
          const contentType = response.headers["content-type"];
          const file = new Blob([response.data], { type: contentType });

          const fileURL = URL.createObjectURL(file);
          const newTab = window.open(fileURL, "_blank");
          newTab.location.href = fileName;
          newTab.onload = function () {
            newTab.document.write(`
          <html>
            <head>
              <title>${fileName}</title>
              <style>
                body {
                  margin: 0;
                  display: flex;
                  align-items: center;
                  justify-content: center;
                  height: 100vh;
                  background-color: black;
                }
                #imageContainer {
                  max-width: 100%;
                  max-height: 100%;
                }
              </style>
            </head>
            <body>
              <div id="imageContainer">
                <embed src="${fileURL}" type="${contentType}" width="100%" height="90%" />
              </div>
            </body>
          </html>
        `);
            newTab.document.close();
          };
        })
        .catch((error) => {
          console.error(error);
        });
    },
    handleOpenFileDWG(fileName, path) {
      console.log("Click Open File PWG: ", fileName, "and path: ", path);
      const jsonData = {
        name: fileName,
        path: path,
      };

      const jsonString = JSON.stringify(jsonData);
      console.log("jsonData: ", jsonData);
      console.log("jsonString: ", jsonString);
      axios
        .post(
          this.$globalVariable.URL_API + "/WeatherForecast/open_file_dwg/",
          jsonString,
          {
            headers: {
              "Content-Type": "application/json",
            },
            responseType: "blob",
          }
        )
        .then((response) => {
          console.log(response.data);
        })
        .catch((error) => {
          console.error(error);
        });
    },
    async handleOpenFileDWGV1(fileName, path) {
      console.log(
        "(handleOpenFileDWGV1) Click Open File PWG: ",
        fileName,
        "and path: ",
        path
      );
      const jsonData = {
        name: fileName,
        path: path,
      };

      const jsonString = JSON.stringify(jsonData);
      console.log("(handleOpenFileDWGV1) jsonData: ", jsonData);
      console.log("(handleOpenFileDWGV1) jsonString: ", jsonString);
      axios
        .post(
          this.$globalVariable.URL_API + "/WeatherForecast/open_file_dwg_v1/",
          jsonString,
          {
            headers: {
              "Content-Type": "application/json",
            },
            responseType: "blob",
          }
        )
        .then((response) => {
          console.log("(handleOpenFileDWGV1) response: ", response.data);
          const blob = new Blob([response.data], {
            type: "application/dwg",
          });
          const url = window.URL.createObjectURL(blob);
          const link = document.createElement("a");
          link.href = url;
          link.download = fileName;
          document.body.appendChild(link);
          link.click();
          document.body.removeChild(link);
          console.log("(handleOpenFileDWGV1) Downloading ... B");
        })
        .catch((error) => {
          console.error(error);
        });
    },
    handleDownloadFilePWG(fileName, path) {
      console.log("Click Download File DWG: ", fileName, "and path: ", path);
      const jsonData = {
        name: fileName,
        path: path,
      };

      const jsonString = JSON.stringify(jsonData);
      console.log("jsonData: ", jsonData);
      console.log("jsonString: ", jsonString);
      axios
        .post(
          this.$globalVariable.URL_API + "/WeatherForecast/download_file_dwg/",
          jsonString,
          {
            headers: {
              "Content-Type": "application/json",
            },
            responseType: "blob",
          }
        )
        .then((response) => {
          console.log(response.data);
          const file = new Blob([response.data], {
            type: "application/octet-stream",
          });
          saveAs(file, `${fileName}`);
        })
        .catch((error) => {
          console.error(error);
        });
    },
    handleOpenFileExcel(fileName, path) {
      console.log("[handleOpenFileExcel] File Name: ", fileName);
      console.log("[handleOpenFileExcel] File Path: ", path);
    },
    handleDownloadFileExcel(fileName, path) {
      console.log("[handleDownloadFileExcel] File Name: ", fileName);
      console.log("[handleDownloadFileExcel] File Path: ", path);
      const jsonData = {
        userID: this.$globalVariable.USER_INFO.userID,
        name: fileName,
        path: path,
      };
      const jsonString = JSON.stringify(jsonData);
      console.log("[handleDownloadFileExcel] Json Data: ", jsonData);
      console.log("[handleDownloadFileExcel] Json String: ", jsonString);
      axios
        .post(
          this.$globalVariable.URL_API + "/WeatherForecast/download_file_excel/",
          jsonString,
          {
            headers: {
              "Content-Type": "application/json",
            },
            responseType: "blob",
          }
        )
        .then((response) => {
          console.log("[handleDownloadFileExcel] Response: ", response);
          const blob = new Blob([response.data], {
            type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
          });
          const link = document.createElement("a");
          link.href = window.URL.createObjectURL(blob);
          link.download = `${fileName}`;
          link.click();
        })
        .catch((error) => {
          console.error("[handleDownloadFileExcel] Error: ", error);
        });
    },
    handleDownloadFileDocs(fileName, path) {
      console.log("[handleDownloadFileDocs] File Name: ", fileName);
      console.log("[handleDownloadFileDocs] File Path: ", path);
      const jsonData = {
        userID: this.$globalVariable.USER_INFO.userID,
        name: fileName,
        path: path,
      };
      const jsonString = JSON.stringify(jsonData);
      console.log("[handleDownloadFileDocs] Json Data: ", jsonData);
      console.log("[handleDownloadFileDocs] Json String: ", jsonString);
      axios
        .post(
          this.$globalVariable.URL_API + "/WeatherForecast/download_file_docs/",
          jsonString,
          {
            headers: {
              "Content-Type": "application/json",
            },
            responseType: "blob",
          }
        )
        .then((response) => {
          console.log("[handleDownloadFileDocs] Response: ", response);
          const blob = new Blob([response.data], {
            type:
              "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
          });
          const link = document.createElement("a");
          link.href = window.URL.createObjectURL(blob);
          link.download = `${fileName}`;
          link.click();
        })
        .catch((error) => {
          console.error("[handleDownloadFileDocs] Error: ", error);
        });
    },
    handleDownloadFilePower(fileName, path) {
      console.log("[handleDownloadFilePower] File Name: ", fileName);
      console.log("[handleDownloadFilePower] File Path: ", path);
      const jsonData = {
        userID: this.$globalVariable.USER_INFO.userID,
        name: fileName,
        path: path,
      };
      const jsonString = JSON.stringify(jsonData);
      console.log("[handleDownloadFilePower] Json Data: ", jsonData);
      console.log("[handleDownloadFilePower] Json String: ", jsonString);
      axios
        .post(
          this.$globalVariable.URL_API + "/WeatherForecast/download_file_docs/",
          jsonString,
          {
            headers: {
              "Content-Type": "application/json",
            },
            responseType: "blob",
          }
        )
        .then((response) => {
          console.log("[handleDownloadFilePower] Response: ", response);
          const blob = new Blob([response.data], {
            type:
              "application/vnd.openxmlformats-officedocument.presentationml.presentation",
          });
          const link = document.createElement("a");
          link.href = window.URL.createObjectURL(blob);
          link.download = `${fileName}`;
          link.click();
        })
        .catch((error) => {
          console.error("[handleDownloadFileDocs] Error: ", error);
        });
    },

    handleDownloadFilePng(fileName, path) {
      console.log("[handleDownloadFilePng] File Name: ", fileName);
      console.log("[handleDownloadFilePng] File Path: ", path);
      const jsonData = {
        userID: this.$globalVariable.USER_INFO.userID,
        name: fileName,
        path: path,
      };
      const jsonString = JSON.stringify(jsonData);
      console.log("[handleDownloadFilePng] Json Data: ", jsonData);
      console.log("[handleDownloadFilePng] Json String: ", jsonString);
      axios
        .post(
          this.$globalVariable.URL_API + "/WeatherForecast/download_file_png/",
          jsonString,
          {
            headers: {
              "Content-Type": "application/json",
            },
            responseType: "blob",
          }
        )
        .then((response) => {
          console.log("[handleDownloadFilePng] Response: ", response);
          const blob = new Blob([response.data], {
            type: "image/png",
          });

          const link = document.createElement("a");
          link.href = window.URL.createObjectURL(blob);
          link.download = `${fileName}`;
          link.click();
        })
        .catch((error) => {
          console.error("[handleDownloadFilePng] Error: ", error);
        });
    },
    processRequestHistory() {
      this.listHistory = [];
      const jsonData = {
        userID: this.$globalVariable.USER_INFO.userID,
      };

      const jsonString = JSON.stringify(jsonData);
      console.log(this.formatDate(), "[processRequestHistory] jsonData: ", jsonData);
      console.log(this.formatDate(), "[processRequestHistory] jsonString: ", jsonString);
      axios
        .post(this.$globalVariable.URL_API + "/History/load_history/", jsonString, {
          headers: {
            "Content-Type": "application/json",
          },
        })
        .then((response) => {
          console.log(
            this.formatDate(),
            "[processRequestHistory] response: ",
            response.data
          );
          const jsonString = response.data;
          console.log(
            this.formatDate(),
            "[processRequestHistory] List: ",
            jsonString.data.length
          );
          for (let i = 0; i < jsonString.data.length; i++) {
            const dataItem = jsonString.data[i];
            const id = dataItem["id"];
            const file_name = dataItem["file_name"];
            const file_path = dataItem["file_path"];
            const date_accessed = dataItem["date_accessed"];
            const action = dataItem["action"];
            console.log(this.formatDate(), "[processRequestHistory] id: ", id);
            console.log(
              this.formatDate(),
              "[processRequestHistory] file_name: ",
              file_name
            );
            console.log(
              this.formatDate(),
              "[processRequestHistory] file_path: ",
              file_path
            );
            console.log(
              this.formatDate(),
              "[processRequestHistory] date_accessed: ",
              date_accessed
            );
            console.log(this.formatDate(), "[processRequestHistory] action: ", action);

            var dataHistory = {
              id: i + 1,
              file_name: file_name,
              file_path: file_path,
              date_accessed: date_accessed,
              action: action,
            };

            this.listHistory.push(dataHistory);
          }
          console.log("[processRequestHistory] List History: ", this.listHistory);
        })
        .catch((error) => {
          console.error(this.formatDate(), "[processRequestHistory] error: ", error);
        });
    },
  },
  updated() {
    this.Number_of_Documents = this.listFiles.length;
    //   console.log('[ComponentTab] sizeAllFiles: ', this.sizeAllFiles);
    //   for(let i = 0; i < this.listFiles.length; i++){
    //     const file = this.listFiles[i];
    //     console.log("\t file: ", file);
    //   }
  },
  watch: {
    activeTab(newValue, oldValue) {
      console.log(
        this.formatDate(),
        "(activeTab) change from [",
        oldValue,
        "] to [",
        newValue,
        "]"
      );
      if (newValue == this.$globalVariable.TAB_RIGHT_ROLES) {
        this.isActiveTableRightAndRoles = true;
      } else {
        this.isActiveTableRightAndRoles = false;
      }
      if (
        newValue == this.$globalVariable.TAB_RIGHT_ROLES ||
        newValue == this.$globalVariable.TAB_GENERAL ||
        newValue == this.$globalVariable.TAB_HISTORY
      ) {
        this.isActiveInformation = false;
      } else {
        this.isActiveInformation = true;
      }
      if (newValue == this.$globalVariable.TAB_FOLDERS) {
        this.isActiveTableFolder = true;
      } else {
        this.isActiveTableFolder = false;
      }
      if (
        newValue == this.$globalVariable.TAB_DOCUMENTS ||
        newValue == this.$globalVariable.TAB_IMAGES ||
        newValue == this.$globalVariable.TAB_FOLDERS
      ) {
        this.isActiveTableFiles = true;
      } else {
        this.isActiveTableFiles = false;
      }
      if (newValue == this.$globalVariable.TAB_GENERAL) {
        this.isActiveTableGeneral = true;
      } else {
        this.isActiveTableGeneral = false;
      }
      if (newValue == this.$globalVariable.TAB_HISTORY) {
        this.isActiveTabHistory = true;
        this.processRequestHistory();
      } else {
        this.isActiveTabHistory = false;
      }
      this.$emit("onChangeTabName", newValue);
    },
    oldListFiles(value) {
      if (value.length > 0) {
        this.vualueSearch = value;
        console.log(
          this.formatDate(),
          "(oldListFiles) vualueSearch: ",
          this.vualueSearch
        );
        this.isCheckOldFile = true;
      } else {
        this.isCheckOldFile = false;
      }
      console.log("[oldListFiles] Is Check Old File: ", this.isCheckOldFile);
      console.log(this.formatDate(), "(oldListFiles) Value: ", value);
    },
    listFiles(newValue, oldValue) {
      console.log(
        this.formatDate(),
        "[file_list] listFiles change from ",
        oldValue,
        "to",
        newValue
      );
      for (let i = 0; i < this.listFiles.length; i++) {
        let fileInfo = this.listFiles[i];
        console.log(this.formatDate(), "[file_list] fileInfo: ", fileInfo);
        console.log(
          this.formatDate(),
          "[file_list] File (",
          i,
          ") :",
          this.listFiles[i].bookmark
        );
        this.isCheckedRowBookmark[i] = this.listFiles[i].bookmark;
      }
    },
    isCheckedRowBookmark(newValue, oldValue) {
      console.log(
        this.formatDate(),
        "[file_list] bookmark change from ",
        oldValue,
        "to",
        newValue
      );
    },
  },
};
</script>

<style scoped>
.component_tab_class {
  position: relative;
  width: 100%;
  font-family: Arial, Helvetica, sans-serif;
  border: 2px solid white;
  height: 100%;
}

.component_tab_class.dragging {
  border: 2px solid #007bff;
  cursor: not-allowed;
}

.tab-container {
  display: flex;
  flex-direction: row;
  width: 100%;
  border: none;
  height: 40px;
  font-family: "Roboto", sans-serif;
  font-size: 14px;
}

.tab {
  padding: 5px 5px;
  padding-top: 8px;
  cursor: pointer;
  border: 2px solid lightgray;
  margin-right: 5px;
  border-radius: 2px;
  text-align: center;
}

.tab_documents {
  width: 10%;
  min-width: 90px;
  border: 1px solid lightgray;
  border-bottom: none;
}

.tab_images {
  width: 10%;
  min-width: 60px;
  border: 1px solid lightgray;
  border-bottom: none;
}

.tab_folders {
  width: 10%;
  min-width: 60px;
  border: 1px solid lightgray;
  border-bottom: none;
}

.tab_rights_roles {
  width: 20%;
  min-width: 110px;
  border: 1px solid lightgray;
  border-bottom: none;
}

.tab_general {
  width: 10%;
  min-width: 65px;
  border: 1px solid lightgray;
  border-bottom: none;
}

.tab_history {
  width: 10%;
  min-width: 60px;
  border: 1px solid lightgray;
  border-bottom: none;
}

.button_drop_file {
  display: flex;
  border: 2px solid #f2f2f2;
  border-radius: 2px;
  height: 40px;
  width: 30%;
  min-width: 200px;
  font-family: "Roboto", sans-serif;
  font-size: 14px;
  cursor: pointer;
  background-color: #fff;
  margin-bottom: 1px;
  text-align: center;
  align-items: center;
  justify-content: center;
  padding: 10px;
  border: 1px solid lightgray;
  border-bottom: none;
}

.tab.active {
  color: black;
  font-weight: bold;
  /* background: linear-gradient(to bottom, #B3E5FC, #f2f2f2); */
  /* background: linear-gradient(to bottom, #BDBDBD, #f2f2f2); */
  background-color: #f2f2f2;
}

.tab-summary {
  display: flex;
  border: 2px solid #f2f2f2;
  height: 45px;
  background-color: #f2f2f2;
  width: 100%;
  justify-content: space-between;
  font-family: "Roboto", sans-serif;
  font-size: 14px;
}

.information {
  display: flex;
  float: left;
  text-align: left;
  border: 1px solid transparent;
  margin-right: 0px;
  padding-top: 5px;
  min-width: 330px;
  justify-content: left;
}

.sum_file {
  padding-left: 10px;
  margin-right: 20px;
  padding-top: 5px;
  border: none;
  white-space: nowrap;
  text-align: center;
  justify-content: center;
  align-items: center;
  vertical-align: middle;
}

.sum_size {
  text-align: center;
  padding-top: 5px;
  border: none;
  white-space: nowrap;
}

.tab-table {
  border: 2px solid #f2f2f2;
  background-color: #fff;
  width: 100%;
  height: calc(100% - 85px);
  overflow-y: auto;
  overflow: auto;
  font-family: "Roboto", sans-serif;
  font-size: 14px;
}

.tab-table.dragging {
  border: 2px solid #1976d2;
  background-color: rgba(144, 202, 249, 0.5);
}

.custom-table {
  width: 100%;
  border-collapse: collapse;
  height: 35px;
  /* table-layout: fixed; */
  border: none;
}

.fix-header {
  position: sticky;
  top: 0;
  background-color: #f2f2f2;
  /* background: linear-gradient(to bottom, #B3E5FC, #fff); */
  /* background: linear-gradient(to bottom, #9E9E9E, #ECEFF1); */
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
}

.custom-table th {
  padding: 8px;
  border: 1px solid #b5b5b5;
  height: 30px;
  text-align: center;
}

.custom-table tr,
.custom-table td {
  /* padding: 8px; */
  border: 1px solid #b5b5b5;
  height: 25px;
}

.th-no {
  width: 40px;
}

.th-title {
  width: 500px;
}

.th-author {
  width: 70px;
}

.th-last_checkin {
  width: 110px;
}

.th-status {
  width: 60px;
}

.th-version {
  width: 20px;
}

.th-size {
  min-width: 90px;
  max-width: 100px;
  width: 93px;
}

.td-description {
  padding-left: 5px;
  text-align: left;
  white-space: pre-line;
}

.th-auto_rev {
  width: 100px;
}

.th-desciption {
  min-width: 214px;
  max-width: 225px;
  width: 217px;
}
.th-document {
  min-width: 215px;
  max-width: 220px;
  width: 216px;
}
.th-language {
  text-align: center;
}

.td-no {
  text-align: center;
}

.td-version {
  text-align: center;
}
.td-size {
  padding-left: 5px;
}

.cell-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 100%;
  text-align: left;
  padding: 2px;
}

.icon-title {
  display: flex;
  align-items: center;
  text-align: left;
  padding: 2px;
  border: 1px solid transparent;
  padding-left: 5px;
}

.icon-file {
  display: flex;
  align-items: center;
  justify-content: center;
  background-size: cover;
  background-position: center;
  border: none;
}

.td-title:hover {
  background-color: #f2f2f2;
}

.td-title-a {
  text-decoration: none;
  color: #1874cd;
  white-space: nowrap;
  /* Ngăn không cho văn bản xuống dòng */
  text-overflow: ellipsis;
  /* Hiển thị dấu ... khi văn bản bị cắt */
  overflow: hidden;
  /* Ẩn nội dung vượt quá chiều dài */
  border: none;
  /* max-width: 450px; */
}

.td-last_checkin {
  text-align: center;
  vertical-align: middle;
}

.td-status {
  text-align: center;
  vertical-align: middle;
}

.circle {
  text-align: center;
  width: 15px;
  height: 15px;
  border-radius: 50%;
  background-color: #008b00;
  margin: auto;
}

.circle.error {
  width: 15px;
  height: 15px;
  border-radius: 50%;
  background-color: #eeb422;
}

.icon_pdf {
  display: inline-block;
  width: 20px;
  height: 25px;
  background-image: url(../assets/pdf.png);
  background-size: cover;
  margin-right: 10px;
}

.icon_dwg {
  display: inline-block;
  width: 20px;
  height: 22px;
  background-image: url(../assets/dwg.png);
  background-size: cover;
  margin-right: 10px;
}

.icon_image {
  display: inline-block;
  width: 20px;
  height: 20px;
  background-image: url(../assets/image.png);
  background-size: cover;
  margin-right: 10px;
}

.icon_word {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/word_1.png);
  background-size: cover;
  margin-right: 10px;
}

.icon_excel {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/excel_1.png);
  background-size: cover;
  margin-right: 10px;
}

.icon_powerpoint {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/powerpoint.png);
  background-size: cover;
  margin-right: 10px;
}

.icon_file {
  display: inline-block;
  width: 20px;
  height: 20px;
  background-image: url(../assets/file.png);
  background-size: cover;
  margin-right: 10px;
}

.icon_winrar {
  display: inline-block;
  width: 24px;
  height: 20px;
  background-image: url(../assets/winrar.jpg);
  background-size: cover;
  margin-right: 10px;
}

.icon_directory {
  display: inline-block;
  width: 24px;
  height: 20px;
  background-image: url(../assets/folder.png);
  background-size: cover;
  margin-right: 10px;
}

.icon_button_drop_file {
  display: inline-block;
  min-width: 20px;
  min-height: 20px;
  background-image: url(../assets/drop_file.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
}

.highlight {
  background-color: red;
  color: #008b00;
}

.option {
  display: flex;
  float: right;
  text-align: center;
  border: 1px solid transparent;
  margin-right: 0px;
  font-family: "Roboto", sans-serif;
  font-size: 14px;
}

.simple-view {
  border: 1px solid transparent;
  padding-bottom: 10px;
  /* min-width: 140px; */
}

.button-simple-view {
  margin-top: 5px;
  display: flex;
  border: 1px solid #f2f2f2;
  border-radius: 4px;
  font-family: "Roboto", sans-serif;
  font-size: 14px;
  cursor: pointer;
  background-color: transparent;
  text-align: bottom;
  align-items: center;
  justify-content: center;
  padding: 10px;
  text-decoration: none;
  height: 35px;
}

.button-simple-view:hover {
  border: 1px solid #64b5f6;
  background-color: #e3f2fd;
}

.icon-simple-view-list {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/images/list_layout.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.icon-simple-view-grid {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/images/grid_layout.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.column-configuration {
  border: none;
  padding-bottom: 10px;
  /* min-width: 220px; */
}

.button-column-configuration {
  margin-top: 5px;
  display: flex;
  border: 1px solid #f2f2f2;
  border-radius: 4px;
  font-family: "Roboto", sans-serif;
  font-size: 14px;
  cursor: pointer;
  background-color: transparent;
  text-align: bottom;
  align-items: center;
  justify-content: center;
  padding: 10px;
  text-decoration: none;
  height: 35px;
}

.button-column-configuration:hover {
  border: 1px solid #64b5f6;
  background-color: #e3f2fd;
}

.icon-column-configuration {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/images/text_columns.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.filter-rows {
  border: none;
  padding-bottom: 10px;
  /* min-width: 140px; */
}

.button-filter-rows {
  margin-top: 5px;
  display: flex;
  border: 1px solid #f2f2f2;
  border-radius: 4px;
  font-family: "Roboto", sans-serif;
  font-size: 14px;
  cursor: pointer;
  background-color: transparent;
  text-align: bottom;
  align-items: center;
  justify-content: center;
  padding: 10px;
  text-decoration: none;
  height: 35px;
}

.button-filter-rows:hover {
  border: 1px solid #64b5f6;
  background-color: #e3f2fd;
}

.icon-filter-rows {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/images/menu_item.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.refresh-list {
  border: none;
  padding-bottom: 10px;
  /* min-width: 110px; */
}

.button-refresh-list {
  margin-top: 5px;
  display: flex;
  border: 1px solid #f2f2f2;
  border-radius: 4px;
  font-family: "Roboto", sans-serif;
  font-size: 14px;
  cursor: pointer;
  background-color: transparent;
  text-align: bottom;
  align-items: center;
  justify-content: center;
  padding: 10px;
  text-decoration: none;
  margin-right: 10px;
  height: 35px;
}

.button-refresh-list:hover {
  border: 1px solid #64b5f6;
  background-color: #e3f2fd;
}

.icon-refresh-list {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/images/refresh.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.th_rightandroles_no {
  width: 50px;
}

.th_rightandroles_fullControl {
  width: 110px;
}

.th_rightandroles_modify {
  width: 100px;
}

.th_rightandroles_readAndExecute {
  width: 150px;
}

.th_rightandroles_write {
  width: 100px;
}

.th_rightandroles_synchronize {
  width: 120px;
}

.td_rightandroles_no {
  text-align: center;
}

.td_rightandroles_username {
  text-align: left;
  padding-left: 5px;
}

.data_rightandroles_username {
  border: 1px solid transparent;
  min-height: 35px;
  padding-top: 7px;
}

.td_rightandroles_fullControl {
  text-align: center;
}

.td_rightandroles_modify {
  text-align: center;
}

.td_rightandroles_readAndExecute {
  text-align: center;
}

.td_rightandroles_write {
  text-align: center;
}

.td_rightandroles_synchronize {
  text-align: center;
}

.container_tab_general {
  position: absolute;
  width: 100%;
  min-height: 300px;
  border: none;
}

.tab_general_name {
  display: flex;
  border: none;
  padding-left: 20px;
  padding-top: 10px;
}

.tab_general_name_title {
  border: none;
  margin-right: 10px;
  width: 120px;
}

.tab_general_name_value {
  border: none;
  margin-right: 10px;
}

.th_history_no {
  width: 50px;
}

.th_history_filepath {
  width: 500px;
}

.th_history_date_accessed {
  width: 200px;
}

.th_history_action {
  width: 100px;
}

.td_history_no {
  text-align: center;
}

.td_history_filename {
  text-align: left;
  padding-left: 5px;
}

.data_history_filename {
  border: 1px solid transparent;
  min-height: 35px;
  padding-top: 7px;
}

.td_history_filepath {
  text-align: left;
  padding-left: 5px;
}

.data_history_filepath {
  border: 1px solid transparent;
  min-height: 35px;
  padding-top: 7px;
}

.td_history_date_accessed {
  text-align: center;
}

.td_history_action {
  text-align: center;
}

.file-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  /* Thay đổi số lượng cột tùy ý */
  /* gap: 10px; */
  /* Khoảng cách giữa các file */
}

@media screen and (max-width: 900px) {
  .hidden-column-vs {
    display: none;
  }
}

@media screen and (max-width: 1280px) {
  .hidden-column-s {
    display: none;
  }

  .file-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
  }
}

@media screen and (max-width: 1700px) {
  .hidden-column-m {
    display: none;
  }
}

/* Setting Screen for GridLayout file */
@media screen and (max-width: 1800px) {
  .file-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
  }
}

@media screen and (max-width: 1200px) {
  .file-grid {
    display: grid;
    grid-template-columns: repeat(1, 1fr);
  }
}

/* Bookmark for row table */
.bookmark {
  display: flex;
  margin-left: 10px;
  border: 1px solid transparent;
  float: right;
}

.star-checkbox {
  display: inline-block;
  position: relative;
  cursor: pointer;
  font-size: 0;
  border: 1px solid transparent;
  width: 30px;
  height: 30px;
  padding-top: 1px;
}

.unchecked-star,
.checked-star {
  cursor: pointer;
  position: relative;
  display: inline-block;
  width: 20px;
  height: 20px;
  margin: 0 2px;
  background-color: transparent;
  border: 2px solid white;
  clip-path: polygon(
    50% 0%,
    61.8% 35.3%,
    98.2% 35.3%,
    68.2% 57.3%,
    79.1% 91.7%,
    50% 70.7%,
    20.9% 91.7%,
    31.8% 57.3%,
    1.8% 35.3%,
    38.2% 35.3%
  );
}

.unchecked-star::before {
  content: "\2605";
  /* Điểm mã Unicode cho ngôi sao đầy */
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  color: white;
  /* Màu của ngôi sao đầy */
  font-size: 22px;
  /* Kích thước của ngôi sao đầy */
  line-height: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  visibility: hidden;
  cursor: pointer;
}

.unchecked-star.hover::before {
  content: "\2605";
  /* Điểm mã Unicode cho ngôi sao đầy */
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  color: grey;
  /* Màu của ngôi sao đầy */
  font-size: 22px;
  /* Kích thước của ngôi sao đầy */
  line-height: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  visibility: hidden;
  cursor: pointer;
}

.checked-star::before {
  content: "\2605";
  /* Điểm mã Unicode cho ngôi sao đầy */
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  color: #c0ca33;
  /* Màu của ngôi sao đầy */
  font-size: 20px;
  /* Kích thước của ngôi sao đầy */
  line-height: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  visibility: hidden;
  cursor: pointer;
}

input[id="checkbox-bookmark"] {
  position: absolute;
  opacity: 0;
}

input[id="checkbox-bookmark"]:checked + .checked-star::before {
  visibility: visible;
}

input[id="checkbox-bookmark"]:not(:checked) + .unchecked-star::before {
  visibility: visible;
}
</style>
