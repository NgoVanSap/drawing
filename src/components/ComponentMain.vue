<template>
  <div class="app" @mousedown="handleMouseDown">
    <ComponentLogin
      v-if="isLoginSuccess"
      v-on:signalLoginSuccess="HandleLoginSuccess"
    ></ComponentLogin>
    <div class="menubar" v-if="!isLoginSuccess" @mouseover="handleMouseOverMenuBar">
      <div class="menu_logo">
        <div class="logo-home">
          <button @click="HandleActionHome" class="button-logo-home">
            <i class="icon-logo-home"></i>
          </button>
        </div>
        <div class="action-version">
          <button @click="HandleActionVersion">V 1.0</button>
        </div>
        <div class="vertial_line"><button>|</button></div>
        <div class="action-help">
          <button @click="HandleActionHelp">{{ $t("Help") }}</button>
        </div>
        <div class="vertial_line"><button>|</button></div>
        <div class="action-hotline">
          <button @click="HandleActionHotline">{{ $t("Hotline") }}</button>
        </div>
      </div>
      <div class="menu_account">
        <button class="open-privilege">
          <i class="icon_account"></i>{{ this.$globalVariable.USER_INFO.fullName }}
        </button>
        <div class="vertial_line"><button>|</button></div>
        <button class="action-logout" @click="HandleLogout">{{ $t("Logout") }}</button>
      </div>
    </div>
    <div class="option" v-if="!isLoginSuccess" @mouseover="handleMouseOverOption">
      <div
        style="
          display: flex;
          float: left;
          border: 1px solid transparent;
          min-width: 180px;
        "
      >
        <PopupComponent v-bind:currentPath="fullPathDirectorySelected"></PopupComponent>
        <PopupNewFile v-bind:currentPath="fullPathDirectorySelected"></PopupNewFile>
      </div>
      <div style="display: flex; float: right; border: 1px solid none">
        <OptionSearch
          v-bind:active_icon_loading="active_icon_loading"
          v-on:signalReloadDataSearch="handleReloadDataSearch"
          v-on:signalClearDataTable="signalClearDataTable"
        ></OptionSearch>
      </div>
    </div>
    <div class="tree-node-main" v-if="!isLoginSuccess">
      <div class="tree-node-content">
        <div class="parent-directory" :style="{ width: widthParentDirectory }">
          <div
            class="tree-node-general"
            style="display: flex"
            @mousedown="startDragDivGeneral"
            @mousemove="handleDragDivGeneral"
            @mouseup="stopDragDivGeneral"
          >
            <div class="layout-left-flex">
              <div
                class="tree-node-directory"
                id="folders"
                ref="contentDivDirectory"
                :style="divTreeNodeDirectoryStyle"
                @mouseover="handleMouseOverTreeNodeDirectory"
                @mousedown="startDragDivDirectory"
                @mousemove="handleDragDivDirectory"
                @mouseup="stopDragDivDirectory"
              >
                <ul>
                  <tree-node
                    v-for="node in tree"
                    :childHightLight="childHightLight"
                    :node="node"
                    :key="node.id"
                    @click="alllowRefeshData"
                    v-on:eventName="handleEmitTreeNode"
                    v-on:handleHighlightColor="handleHighlightColor"
                    v-on:isDataSearch="handleIsDataSearch"
                    :isMouseTreeNodeDirectory="isMouseTreeNodeDirectory"
                    :isLoading="isLoadingTreeNodeItem"
                    :isBrowse="false"
                    v-on:signalUpdateTreeNodeItem="handleUpdateTreeNodeItem"
                  ></tree-node>
                </ul>
              </div>
              <div
                v-if="isActiveBrowseDirectory"
                class="tree-node-browse"
                ref="contentDivBrowse"
                :style="{ height: divHeightTreeNodeBrowse }"
                @mouseover="handleMouseOverTreeNodeBrowse"
                @mousedown="startDragDivBrowse"
                @mousemove="handleDragDivBrowse"
                @mouseup="stopDragDivBrowse"
              >
                <ul>
                  <tree-node
                    v-for="node in treeBrowse"
                    :node="node"
                    :key="node.id"
                    v-on:eventName="handleEmitTreeNode"
                    v-on:handleHighlightColor="handleHighlightColor"
                    :isMouseTreeNodeDirectory="isMouseTreeNodeBrowse"
                    :isLoading="isLoadingTreeNodeItem"
                    :isBrowse="true"
                    v-on:signalUpdateTreeNodeItem="handleUpdateTreeNodeItem"
                  ></tree-node>
                </ul>
              </div>
            </div>
            <div
              class="layout-right-flex"
              ref="parentDirectory"
              @mousedown="startResizeParentDirectory"
            ></div>
          </div>
          <div class="directory-option" @mouseover="handleMouseOverDirectoryOption">
            <div
              class="browse-directory"
              :class="{ active: isActiveBrowseDirectory }"
              @click="toggleActiveBrowseDirectory"
            >
              <button @click="HandleBrowse" class="button-browse-directory">
                <i
                  v-if="!active_icon_loading_browse"
                  class="icon-browse-directory"
                  :class="{ active: isActiveBrowseDirectory }"
                ></i
                ><i v-if="active_icon_loading_browse" class="icon_loading"></i
                >{{ $t("Browse") }}
              </button>
            </div>
            <div
              class="favorites-directory"
              :class="{ active: isActiveFavovitesDirectory }"
              @click="toggleActiveFavovitesDirectory"
            >
              <button @click="HandleFavorites" class="button-browse-directory">
                <i
                  v-if="!active_icon_loading_favorites"
                  class="icon-favorites-directory"
                  :class="{ active: isActiveFavovitesDirectory }"
                ></i
                ><i v-if="active_icon_loading_favorites" class="icon_loading"></i
                >{{ $t("Favorites") }}
              </button>
            </div>
            <div
              class="home-directory"
              :class="{ active: isActiveHomeDirectory }"
              @click="toggleActiveHomeDirectory"
            >
              <button @click="HandleHome" class="button-browse-directory">
                <i
                  v-if="!active_icon_loading_home"
                  class="icon-home-directory"
                  :class="{ active: isActiveHomeDirectory }"
                ></i
                ><i v-if="active_icon_loading_home" class="icon_loading"></i
                >{{ $t("Home") }}
              </button>
            </div>
          </div>
        </div>
        <div
          class="tree-node-file"
          :style="{ width: widthTreeNodeFile }"
          id="table"
          @mouseover="handleMouseOverTreeNodeFile"
        >
          <div class="component-select">
            <div class="item-select">
              <p><i class="directorySelectedClass"></i>{{ directorySelected }}</p>
            </div>
            <div class="menu-select">
              <div class="setting-language">
                <button @click="HandleSettingLanguage" class="button-setting-language">
                  <i
                    :class="
                      this.$globalVariable.USER_INFO.language == 1
                        ? 'icon-setting-language'
                        : 'icon-setting-language-vietNames'
                    "
                  ></i
                  >{{ $t("Language") }}
                </button>
                <v-dialog v-model="dialogFormChangeLanguages" persistent width="400">
                  <v-card>
                    <v-form v-model="isFormChangeLanguage" class="">
                      <v-card-title
                        style="
                          display: flex;
                          align-items: center;
                          justify-content: center;
                          background: black;
                          color: white;
                          font-size: 14px;
                          margin-bottom: 25px;
                        "
                        >{{ $t("TitleLanguage") }}<i class="icon-translate"></i
                      ></v-card-title>
                      <v-card-text>
                        <v-select
                          v-model="userInfo.language"
                          :items="languages"
                          :label="$t('Language')"
                        ></v-select>
                      </v-card-text>
                      <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn
                          class="elevation-2"
                          variant="text"
                          @click="
                            dialogFormChangeLanguages = false;
                            isSnackbar = false;
                          "
                          style="font-family: 'Poppins', sans-serif"
                        >
                          {{ $t("Close") }}
                        </v-btn>
                        <v-btn
                          class="elevation-2"
                          variant="text"
                          @click="HandleChangeLanguage"
                          style="font-family: 'Poppins', sans-serif"
                        >
                          {{ $t("Save") }}
                        </v-btn>
                      </v-card-actions>
                    </v-form>
                  </v-card>
                </v-dialog>
              </div>
              <div class="setting-user">
                <button @click="HandleSettingUser" class="button-setting-user">
                  <i class="icon-setting-user"></i>{{ $t("Profile") }}
                </button>
              </div>
              <v-row justify="center">
                <v-dialog v-model="dialog" persistent width="1024">
                  <v-card>
                    <v-form v-model="isFormChangeProfile" class="">
                      <v-card-title
                        style="background: black; color: white; margin-bottom: 9px"
                      >
                        <span
                          class="text-h5"
                          style="
                            padding-bottom: 20px;
                            font-size: 14px !important;
                            font-weight: 700;
                          "
                          >{{ $t("ProfileInformation") }}</span
                        >
                      </v-card-title>
                      <v-card-text>
                        <v-container>
                          <v-row>
                            <v-col cols="12" class="p-0">
                              <v-text-field
                                :label="$t('FullNameInfo')"
                                v-model="userInfo.fullName"
                                :rules="[rules.required]"
                              ></v-text-field>
                            </v-col>
                            <v-col cols="12" class="p-0">
                              <v-text-field
                                v-model="userInfo.userID"
                                disabled
                              ></v-text-field>
                            </v-col>
                            <v-col cols="12" class="p-0">
                              <v-select
                                v-model="userInfo.jobPosition"
                                :key="userInfo.jobPosition"
                                :items="jobPositionItems"
                                label="userInfo.jobPosition"
                                persistent-hint
                                return-object
                                single-line
                              ></v-select>
                            </v-col>
                            <v-col cols="12" class="p-0">
                              <v-select
                                v-model="userInfo.area"
                                :items="areaList"
                                label="userInfo.area"
                                persistent-hint
                                return-object
                                single-line
                              ></v-select>
                            </v-col>
                            <v-col cols="12" class="p-0">
                              <v-label>{{ $t("WorkingHours") }}:</v-label>
                              <v-radio-group column v-model="userInfo.gioLam">
                                <v-radio
                                  :label="$t('Administrative')"
                                  value="1"
                                ></v-radio>
                                <v-radio :label="$t('Kip')" value="2"></v-radio>
                              </v-radio-group>
                              <v-select
                                v-model="userInfo.kip"
                                :items="itemKIP"
                                solo
                                label="userInfo.kip"
                                v-if="userInfo.gioLam == 2"
                                persistent-hint
                                return-object
                                single-line
                              ></v-select>
                            </v-col>
                            <v-col cols="12" class="p-0">
                              <v-text-field
                                v-model="userInfo.email"
                                label="Email"
                                :rules="[rules.required, rules.email, rules.formatEmail]"
                              ></v-text-field>
                            </v-col>
                          </v-row>
                        </v-container>
                        <div
                          class="title-bottom-form"
                          style="display: flex; justify-content: space-between"
                        >
                          <small>*{{ $t("Required") }}</small>
                          <small
                            class="title-change_password"
                            @click="handleDialogFormChangePass"
                            style="cursor: pointer"
                            >{{ $t("ChangePassword") }}</small
                          >
                        </div>
                      </v-card-text>
                      <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn
                          class="elevation-2"
                          variant="text"
                          @click="
                            dialog = false;
                            isSnackbar = false;
                          "
                          style="font-family: 'Poppins', sans-serif"
                        >
                          {{ $t("Close") }}
                        </v-btn>
                        <v-btn
                          class="elevation-2"
                          variant="text"
                          @click="handleChangeProfile"
                          style="font-family: 'Poppins', sans-serif"
                        >
                          {{ $t("Save") }}
                        </v-btn>
                        <v-snackbar
                          v-if="showSnackbar"
                          v-model="showSnackbar"
                          :color="snackbarColor"
                          :timeout="2000"
                        >
                          {{ message }}
                        </v-snackbar>
                      </v-card-actions>
                    </v-form>
                  </v-card>
                </v-dialog>
                <v-dialog v-model="dialogFormChangePass" persistent width="550">
                  <v-card>
                    <v-form v-model="isFormChangePassword" class="">
                      <v-card-title
                        style="background: black; color: white; margin-bottom: 9px"
                      >
                        <span
                          class="text-h5"
                          style="
                            padding-bottom: 20px;
                            font-size: 14px !important;
                            font-weight: 700;
                          "
                          >{{ $t("TitleChangePassword") }}</span
                        >
                      </v-card-title>
                      <v-card-text>
                        <v-container>
                          <v-row>
                            <v-col cols="12" class="p-0">
                              <v-text-field
                                :label="$t('OldPassword')"
                                v-model="userInfo.password"
                                :rules="[apiError == true ? [] : rules.required]"
                                type="password"
                              ></v-text-field>
                            </v-col>
                            <v-col cols="12" class="p-0">
                              <v-text-field
                                :label="$t('NewPassword')"
                                :rules="[
                                  apiError == true ? [] : rules.required,
                                  rules.passwordMatch,
                                ]"
                                v-model="userInfo.newPassword"
                                type="password"
                              ></v-text-field>
                            </v-col>
                            <v-col cols="12" class="p-0">
                              <v-text-field
                                :label="$t('ConfirmPassword')"
                                :rules="[
                                  apiError == true ? [] : rules.required,
                                  rules.confirmPassword,
                                ]"
                                v-model="userInfo.confirmPassword"
                                type="password"
                              ></v-text-field>
                            </v-col>
                          </v-row>
                        </v-container>
                        <div
                          class="title-bottom-form"
                          style="display: flex; justify-content: space-between"
                        >
                          <small>*{{ $t("Required") }}</small>
                        </div>
                      </v-card-text>
                      <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn
                          class="elevation-2"
                          variant="text"
                          @click="
                            dialogFormChangePass = false;
                            isSnackbar = false;
                          "
                          style="font-family: 'Poppins', sans-serif"
                        >
                          {{ $t("Close") }}
                        </v-btn>
                        <v-btn
                          class="elevation-2"
                          variant="text"
                          @click="handleChangePassword"
                          style="font-family: 'Poppins', sans-serif"
                        >
                          {{ $t("Save") }}
                        </v-btn>
                        <v-snackbar
                          v-if="showSnackbar"
                          v-model="showSnackbar"
                          :color="snackbarColor"
                          :timeout="2000"
                        >
                          {{ message }}
                        </v-snackbar>
                      </v-card-actions>
                    </v-form>
                  </v-card>
                </v-dialog>
              </v-row>
            </div>
          </div>
          <div class="tab-content">
            <ComponentTab
              @isViewListLayout="handleIsViewListLayout"
              :listFiles="listFiles"
              :listRightAndRoles="listRightAndRoles"
              :isCheckRightandRoles_fullControl="isCheckRightandRoles_fullControl"
              :isCheckRightandRoles_modify="isCheckRightandRoles_modify"
              :isCheckRightandRoles_readAndExecute="isCheckRightandRoles_readAndExecute"
              :isCheckRightandRoles_write="isCheckRightandRoles_write"
              :isCheckRightandRoles_synchronize="isCheckRightandRoles_synchronize"
              :sizeAllFiles="sizeAllFiles"
              :menuVisible="menuVisible"
              :oldListFiles="oldListFiles"
              :checkTab="checkTab"
              :currentPath="fullPathDirectorySelected"
              v-on:signal_show_menu="slot_show_menu"
              v-on:signal_close_menu="slot_close_menu"
              v-on:onChangeTabName="HandleChangeTabName"
              v-on:handleHighlightFromTab="handleHighlightFrom"
              v-on:signalReloadDataAfterDropFiles="HandleReloadDataAfterDropFiles"
              v-on:signalReloadDataByFilterRows="HandleReloadDataByFilterRows"
              v-on:signalReloadDataByRefresh="HandleReloadDataByRefresh"
              v-on:signal_remove_file_bookmark="handle_remove_file_bookmark"
              v-on:signalHandleSaveList="HandleSaveListContent"
            ></ComponentTab>
          </div>
          <div class="table_info">
            <div class="table_info_data">
              {{ $t("View") }} 1 - {{ this.numberOfView }} {{ $t("Of") }}
              {{ this.numberOfView }}
            </div>
          </div>
        </div>
      </div>
    </div>
    <ComponentPrivilege
      v-bind:isActiveFormPrivilege="isActiveFormPrivilege"
      v-on:signalCloseFormPrivilege="HandleCloseFormPrivilege"
    ></ComponentPrivilege>
    <ComponentHotline
      v-bind:isActiveFormHotline="isActiveFormHotline"
      v-on:signalCloseFormHotline="HandleCloseFormHotline"
    ></ComponentHotline>
    <ComponentRelease
      v-bind:isActiveFormRelease="isActiveFormRelease"
      v-on:signalCloseFormRelease="HandleCloseFormRelease"
    ></ComponentRelease>
  </div>
</template>

<script>
import moment from "moment";
import axios from "axios";
import { saveAs } from "file-saver";
import TreeNode from "../components/TreeNode.vue";
import ComponentTab from "./ComponentTab.vue";
import PopupComponent from "./PopupComponent.vue";
import PopupNewFile from "./PopupNewFile.vue";
import OptionSearch from "./OptionSearch.vue";
import ComponentLogin from "./ComponentLogin.vue";
import ComponentPrivilege from "./ComponentPrivilege.vue";
import ComponentHotline from "./ComponentHotline.vue";
import ComponentRelease from "./ComponentRelease.vue";
import { JOB_POSITION_ITEMS, AREA_LIST, LANGUAGES } from "../js/dataUser";
import ExcelJS from "exceljs";

export default {
  name: "ComponentMain",
  components: {
    TreeNode,
    ComponentTab,
    PopupComponent,
    PopupNewFile,
    OptionSearch,
    ComponentLogin,
    ComponentPrivilege,
    ComponentHotline,
    ComponentRelease,
  },
  data() {
    return {
      isFormAddNewFolderVisible: false,
      menuItems: [
        {
          id: 1,
          name: "Menu 1",
          visible: false,
          content: "Content 1",
        },
        {
          id: 2,
          name: "Menu 2",
          visible: false,
          content: "Content 2",
        },
        {
          id: 3,
          name: "Menu 3",
          visible: false,
          content: "Content 3",
        },
      ],
      iconLanguage: false,
      isDataSearch: false,
      childHightLight: "",
      tree: [],
      childrenTree: [],
      treeBrowse: [],
      listFiles: [],
      dataHighlightFolder: [],
      listFilesSearch: [],
      oldListFiles: [],
      oldUserInfoArray: null,
      dataOriginal: "",
      listRightAndRoles: [],
      isCheckRightandRoles_fullControl: [],
      isCheckRightandRoles_modify: [],
      isCheckRightandRoles_readAndExecute: [],
      isCheckRightandRoles_write: [],
      isCheckRightandRoles_synchronize: [],
      lastIdTree: 0,
      nameParent: "ABC",
      ageParent: 10,
      directorySelected: "/",
      fullPathDirectorySelected: "/",
      sizeAllFiles: "",
      menuVisible: false,
      menuVisibleGridLayout: false,
      active_icon_loading: false,
      isLoginSuccess: true,
      isActiveFormPrivilege: false,
      isActiveFormHotline: false,
      isActiveFormRelease: false,
      isActiveBrowseDirectory: false,
      isActiveFavovitesDirectory: false,
      isActiveHomeDirectory: true,
      numberOfView: 0,
      isDragging: false,
      isFormChangeProfile: false,
      dialog: false,
      showSnackbar: false,
      dialogFormChangePass: false,
      dialogFormChangeLanguages: false,
      selectedLanguage: null,
      apiError: false,
      tabCheckLanguage: "",
      isCheckViewListLayout: true,
      userInfo: {
        fullName: "",
        userID: "",
        jobID: "",
        jobPosition: "",
        areaID: "",
        area: "",
        workID: "",
        gioLam: "",
        kipID: "",
        kip: "",
        email: "",
        password: "",
        newPassword: "",
        confirmPassword: "",
        language: "",
      },

      itemKIP: ["A", "B", "C"],
      languages: LANGUAGES,
      jobPositionItems: JOB_POSITION_ITEMS,
      areaList: AREA_LIST,
      rules: {
        required: (value) => !!value || this.$t("Compulsory"),
        email: (value) => {
          const pattern = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
          return pattern.test(value) || this.$t("InvalidEmail");
        },
        formatEmail: (value) =>
          !!value.includes("hoaphat.com.vn") || this.$t("NonCompanyEmail"),
        passwordMatch: (value) => {
          if (!this.userInfo.password) {
            return true;
          }
          return value != this.userInfo.password || this.$t("SameNewAndOldPassword");
        },
        confirmPassword: (value) =>
          value === this.userInfo.newPassword || this.$t("SameNewPassword"),
      },
      snackbar: false,
      message: "",
      snackbarColor: "success",
      active_icon_loading_browse: false,
      active_icon_loading_favorites: false,
      active_icon_loading_home: false,
      isMouseTreeNodeDirectory: false,
      isMouseTreeNodeBrowse: false,
      isLoadingTreeNodeItem: [],
      divHeightTreeNodeDirectory: "calc(100%)",
      divHeightTreeNodeBrowse: "350px",
      divBorderRadiusBottomLeftTreeNodeDirectory: "6px",
      divBorderRadiusBottomRightTreeNodeDirectory: "6px",
      fullPathDirectoryBrowseBefore: "/",
      fullPathDirectoryBrowseAfter: "/",
      fullPathDirectory: "/",
      isDraggingDivBrowse: false,
      startY: 0,
      isClickItemTreeNode: false,
      highlightedNodes: [],
      isResizing: true,
      widthParentDirectory: "20%",
      widthTreeNodeFile: "80%",
      checkTab: false,
    };
  },
  methods: {
    formatDate() {
      let datetime = new Date();
      return "[" + moment(datetime).format("DD-MM-YYYY HH:mm:ss.SSS") + "]";
    },
    alllowRefeshData() {
      if (this.isDataSearch) {
        this.isDataSearch = false;
      }
    },
    processUpdateBookmark(tree_item, location, status) {
      console.log(
        this.formatDate(),
        "(processUpdateBookmark) tree_item: ",
        tree_item.length
      );
      let result = false;
      for (let i = 0; i < tree_item.length; i++) {
        const treeItem = tree_item[i];
        if (treeItem.fullName == location) {
          treeItem.bookmark = status;
          result = true;
          break;
        }
        if (treeItem.children.length > 0) {
          if (this.processUpdateBookmark(treeItem.children, location, status)) {
            result = true;
            break;
          }
        }
      }
      return result;
    },
    handleUpdateTreeNodeItem(params) {
      console.log(this.formatDate(), "(ComponentMain) handleUpdateTreeNodeItem");
      const { name, location, status, isExpanded, tabSelected } = params;
      console.log(this.formatDate(), "(ComponentMain) name: ", name);
      console.log(this.formatDate(), "(ComponentMain) location: ", location);
      console.log(this.formatDate(), "(ComponentMain) status: ", status);
      console.log(this.formatDate(), "(ComponentMain) isExpanded: ", isExpanded);
      console.log(this.formatDate(), "(ComponentMain) tabSelected: ", tabSelected);
      console.log(this.formatDate(), "(ComponentMain) tree_length: ", this.tree.length);

      let result = false;
      for (let i = 0; i < this.tree.length; i++) {
        const treeItem = this.tree[i];
        // const id = treeItem.id;
        // const Name = treeItem.name;
        const FullName = treeItem.fullName;
        // const bookmark = treeItem.bookmark;
        // const isExpanded = treeItem.isExpanded;
        // const isTabFavorites = treeItem.isTabFavorites;
        // const children = treeItem.children.length;

        // console.log(this.formatDate(), "(ComponentMain) checking index: ", i);
        // console.log(this.formatDate(), "\t id: ", id);
        // console.log(this.formatDate(), "\t Name: ", Name);
        // console.log(this.formatDate(), "\t FullName: ", FullName);
        // console.log(this.formatDate(), "\t bookmark: ", bookmark);
        // console.log(this.formatDate(), "\t isExpanded: ", isExpanded);
        // console.log(this.formatDate(), "\t isTabFavorites: ", isTabFavorites);
        // console.log(this.formatDate(), "\t children: ", children);
        if (FullName == location) {
          treeItem.bookmark = status;
          result = true;
          if (tabSelected == 2) {
            this.tree = [...this.tree.slice(0, i), ...this.tree.slice(i + 1)];
          }
          break;
        } else {
          if (this.processUpdateBookmark(treeItem.children, location, status)) {
            result = true;
            break;
          }
        }
      }

      console.log(this.formatDate(), "(ComponentMain) result_tree: ", result);
      result = false;

      for (let i = 0; i < this.treeBrowse.length; i++) {
        const treeItem = this.treeBrowse[i];
        // const id = treeItem.id;
        // const Name = treeItem.name;
        const FullName = treeItem.fullName;
        // const bookmark = treeItem.bookmark;
        // const isExpanded = treeItem.isExpanded;
        // const isTabFavorites = treeItem.isTabFavorites;
        // const children = treeItem.children.length;

        // console.log(this.formatDate(), "(ComponentMain) checking index: ", i);
        // console.log(this.formatDate(), "\t id: ", id);
        // console.log(this.formatDate(), "\t Name: ", Name);
        // console.log(this.formatDate(), "\t FullName: ", FullName);
        // console.log(this.formatDate(), "\t bookmark: ", bookmark);
        // console.log(this.formatDate(), "\t isExpanded: ", isExpanded);
        // console.log(this.formatDate(), "\t isTabFavorites: ", isTabFavorites);
        // console.log(this.formatDate(), "\t children: ", children);
        if (FullName == location) {
          treeItem.bookmark = status;
          result = true;
          if (tabSelected == 2) {
            this.treeBrowse = [
              ...this.treeBrowse.slice(0, i),
              ...this.treeBrowse.slice(i + 1),
            ];
          }
          break;
        } else {
          if (this.processUpdateBookmark(treeItem.children, location, status)) {
            result = true;
            break;
          }
        }
      }
      console.log(this.formatDate(), "(ComponentMain) result_tree_browse: ", result);
    },
    startDragDivGeneral(event) {
      // console.log("(DragDiv) [General] Start");
      event.preventDefault();
    },
    handleDragDivGeneral() {
      // console.log("(DragDiv) [General] Handle");
    },
    stopDragDivGeneral() {
      // console.log("(DragDiv) [General] Stop");
      this.isDraggingDivBrowse = false;
    },
    startDragDivDirectory() {
      // console.log("(DragDiv) [Directory] Start");
    },
    // handleMouseEnter() {
    //     const parentDirectory = this.$refs.parentDirectory;
    //     parentDirectory.style.cursor = 'e-resize';
    //     parentDirectory.style.userSelect = 'none';
    // },
    startResizeParentDirectory(event) {
      event.preventDefault();
      this.isResizing = true;
      document.addEventListener("mousemove", this.handleMouseMoveParentDirectory);
      document.addEventListener("mouseup", this.handleMouseUp);
    },

    handleMouseMoveParentDirectory(event) {
      const div = this.$refs.parentDirectory;
      if (div) {
        const divRect = div.getBoundingClientRect();
        if (divRect) {
          const mouseX = event.clientX;
          const isMouseAtRightEdgeLeft =
            mouseX >= divRect.left + divRect.width - 200 &&
            mouseX <= divRect.left + divRect.width;
          const isMouseAtRightEdgeRight =
            mouseX >= divRect.left + divRect.width &&
            mouseX <= divRect.left + divRect.width + 200;
          const isMouseAtRightHoverLeft =
            mouseX >= divRect.left + divRect.width - 30 &&
            mouseX <= divRect.left + divRect.width;
          const isMouseAtRightHoverRight =
            mouseX >= divRect.left + divRect.width &&
            mouseX <= divRect.left + divRect.width + 10;

          if (isMouseAtRightHoverRight || isMouseAtRightHoverLeft) {
            document.body.style.cursor = "e-resize";
          } else {
            document.body.style.cursor = "default";
          }
          if (isMouseAtRightEdgeLeft || isMouseAtRightEdgeRight) {
            if (this.isResizing) {
              let newWidth = event.clientX;
              newWidth = Math.min(newWidth, 670);
              this.widthParentDirectory = `${newWidth}px`;
              let widthString = "calc(100% - " + this.widthParentDirectory + ")";
              this.widthTreeNodeFile = widthString;
            }
          }
        }
      }
    },
    handleMouseUp() {
      this.isResizing = false;
    },
    handleDragDivDirectory(event) {
      if (this.isDraggingDivBrowse) {
        const deltaY = event.clientY - this.startY;
        console.log("(DragDiv) [Directory] deltaY: ", deltaY);
        let divHeight = this.divHeightTreeNodeBrowse;
        divHeight = divHeight.replace("+", "").replace("px", "");
        const newHeight = parseInt(divHeight) - deltaY;
        console.log("(DragDiv) [Directory] divHeight: ", divHeight);
        console.log("(DragDiv) [Directory] newHeight: ", newHeight);

        const myDivDirectory = this.$refs.contentDivDirectory;
        const divHeightDirectory = myDivDirectory.clientHeight + deltaY;
        if (newHeight >= 0 && newHeight > 100 && divHeightDirectory > 100) {
          this.divHeightTreeNodeBrowse = "+" + newHeight + "px";
          this.divHeightTreeNodeDirectory = "calc(100% - " + newHeight + "px)";
        }

        this.startY = event.clientY;
      }
    },
    stopDragDivDirectory() {
      // console.log("(DragDiv) [Directory] Stop");
    },
    startDragDivBrowse(event) {
      // console.log("(DragDiv) [Browse] Start");
      event.preventDefault();
      this.isDraggingDivBrowse = true;
      this.startY = event.clientY;
    },
    handleDragDivBrowse(event) {
      if (this.isDraggingDivBrowse) {
        // console.log("(DragDiv) [Browse] Handle");
        const deltaY = event.clientY - this.startY;
        // console.log("(DragDiv) [Browse] deltaY: ", deltaY);
        let divHeight = this.divHeightTreeNodeBrowse;
        divHeight = divHeight.replace("+", "").replace("px", "");
        const newHeight = parseInt(divHeight) - deltaY;
        // console.log("(DragDiv) [Browse] divHeight: ", divHeight);
        // console.log("(DragDiv) [Browse] newHeight: ", newHeight);

        const myDivDirectory = this.$refs.contentDivDirectory;
        const divHeightDirectory = myDivDirectory.clientHeight + deltaY;
        // console.log("(DragDiv) [Browse] divHeightDirectory: ", divHeightDirectory);

        // Giới hạn chiều cao để không âm và không quá lớn
        if (newHeight >= 0 && newHeight > 100 && divHeightDirectory > 100) {
          this.divHeightTreeNodeBrowse = "+" + newHeight + "px";
          this.divHeightTreeNodeDirectory = "calc(100% - " + newHeight + "px)";
        }

        this.startY = event.clientY;
        // console.log("(DragDiv) [Browse] Directory: ", this.divHeightTreeNodeDirectory);
        // console.log("(DragDiv) [Browse] Browse: ", this.divHeightTreeNodeBrowse);
      }
    },
    stopDragDivBrowse() {
      // console.log("(DragDiv) [Browse] Stop");
    },
    handleIsViewListLayout(value) {
      this.isCheckViewListLayout = value;
      if (this.isCheckViewListLayout == true) {
        this.$globalVariable.TEXT_LAYOUT = this.$t("ListLayout");
      } else {
        this.$globalVariable.TEXT_LAYOUT = this.$t("GridLayout");
      }
      console.log(
        "(handleIsViewListLayout)  isCheckViewListLayout: ",
        this.isCheckViewListLayout
      );
    },
    handleMouseOverMenuBar() {
      this.isMouseTreeNodeDirectory = false;
      this.isMouseTreeNodeBrowse = false;
      this.isDraggingDivBrowse = false;
    },
    handleMouseOverOption() {
      this.isMouseTreeNodeDirectory = false;
      this.isMouseTreeNodeBrowse = false;
      this.isDraggingDivBrowse = false;
    },
    handleMouseOverTreeNodeDirectory() {
      this.isMouseTreeNodeDirectory = true;
      this.isMouseTreeNodeBrowse = false;
    },
    handleMouseOverTreeNodeBrowse() {
      this.isMouseTreeNodeDirectory = false;
      this.isMouseTreeNodeBrowse = true;
    },
    handleMouseOverDirectoryOption() {
      this.isMouseTreeNodeDirectory = false;
      this.isMouseTreeNodeBrowse = false;
      this.isDraggingDivBrowse = false;
    },
    handleMouseOverTreeNodeFile() {
      this.isMouseTreeNodeDirectory = false;
      this.isMouseTreeNodeBrowse = false;
      this.isDraggingDivBrowse = false;
    },
    handle_remove_file_bookmark(index) {
      console.log(
        this.formatDate(),
        "[file_list] handle_remove_file_bookmark index: ",
        index
      );
      if (this.isClickItemTreeNode == false) {
        this.listFiles = [
          ...this.listFiles.slice(0, index),
          ...this.listFiles.slice(index + 1),
        ];
      }
      this.toggleActiveFavovitesDirectory();
    },
    HandleReloadDataByRefresh() {
      console.log(
        this.formatDate(),
        "[HandleRefreshList] componentMain: ",
        this.$globalVariable.DATA_RESPONSE_REFRESH
      );
      this.dataOriginal = this.$globalVariable.DATA_RESPONSE_REFRESH;
      this.HandleChangeTabName(this.$globalVariable.TAB_CURRENT);
    },
    HandleReloadDataByFilterRows() {
      console.log(
        this.formatDate(),
        "[ComponentFilterRows] (componentMain) slot handle Ok"
      );
      this.HandleChangeTabName(this.$globalVariable.TAB_CURRENT);
    },
    ModuleFilterRows(file) {
      if (this.$globalVariable.FILTER_ROWS.is_active == true) {
        console.log("[ComponentFilterRows] (ModuleFilterRows) file: ", file);
        const id = file["id"];
        const FullName = file["Name"];
        const Data = file["Data"];
        const detail_Name = Data["Name"];
        const detail_LastWriteTime = Data["LastWriteTime"];
        const detail_CreationTime = Data["CreationTime"];
        const detail_DirectoryName = Data["DirectoryName"];
        const detail_Extension = Data["Extension"];
        const detail_IsReadOnly = Data["IsReadOnly"] === true;
        const detail_LastAccessTime = Data["LastAccessTime"];
        const detail_Length = Data["Length"];
        const detail_Size = Data["Size"];
        const detail_description = Data["description"];
        const detail_document_number = Data["document_number"];

        console.log("[ComponentFilterRows] (ModuleFilterRows) id: ", id);
        console.log("[ComponentFilterRows] (ModuleFilterRows) FullName: ", FullName);
        console.log(
          "[ComponentFilterRows] (ModuleFilterRows) detail_Name: ",
          detail_Name
        );
        console.log(
          "[ComponentFilterRows] (ModuleFilterRows) detail_LastWriteTime: ",
          detail_LastWriteTime
        );
        console.log(
          "[ComponentFilterRows] (ModuleFilterRows) detail_CreationTime: ",
          detail_CreationTime
        );
        console.log(
          "[ComponentFilterRows] (ModuleFilterRows) detail_DirectoryName: ",
          detail_DirectoryName
        );
        console.log(
          "[ComponentFilterRows] (ModuleFilterRows) detail_Extension: ",
          detail_Extension
        );
        console.log(
          "[ComponentFilterRows] (ModuleFilterRows) detail_IsReadOnly: ",
          detail_IsReadOnly
        );
        console.log(
          "[ComponentFilterRows] (ModuleFilterRows) detail_LastAccessTime: ",
          detail_LastAccessTime
        );
        console.log(
          "[ComponentFilterRows] (ModuleFilterRows) detail_Length: ",
          detail_Length
        );
        console.log(
          "[ComponentFilterRows] (ModuleFilterRows) detail_Size: ",
          detail_Size
        );
        console.log(
          "[ComponentFilterRows] (ModuleFilterRows) detail_description: ",
          detail_description
        );
        console.log(
          "[ComponentFilterRows] (ModuleFilterRows) detail_description: ",
          detail_document_number
        );

        console.log("[ComponentFilterRows] (ModuleFilterRows) Check title");
        // ------------------------------------------- Check title ---------------------------------------------------
        if (this.$globalVariable.FILTER_ROWS.title_value != "") {
          if (this.$globalVariable.FILTER_ROWS.title_option == "Equals") {
            if (this.$globalVariable.FILTER_ROWS.title_value != detail_Name) {
              return false;
            }
          } else if (this.$globalVariable.FILTER_ROWS.title_option == "Does not equals") {
            if (this.$globalVariable.FILTER_ROWS.title_value == detail_Name) {
              return false;
            }
          } else if (this.$globalVariable.FILTER_ROWS.title_option == "Begin with") {
            if (
              detail_Name.startsWith(this.$globalVariable.FILTER_ROWS.title_value) ==
              false
            ) {
              return false;
            }
          } else if (
            this.$globalVariable.FILTER_ROWS.title_option == "Does not begin with"
          ) {
            if (detail_Name.startsWith(this.$globalVariable.FILTER_ROWS.title_value)) {
              return false;
            }
          } else if (this.$globalVariable.FILTER_ROWS.title_option == "End with") {
            if (
              detail_Name.endsWith(this.$globalVariable.FILTER_ROWS.title_value) == false
            ) {
              return false;
            }
          } else if (
            this.$globalVariable.FILTER_ROWS.title_option == "Does not end with"
          ) {
            if (detail_Name.endsWith(this.$globalVariable.FILTER_ROWS.title_value)) {
              return false;
            }
          } else if (this.$globalVariable.FILTER_ROWS.title_option == "Contains") {
            if (
              detail_Name.includes(this.$globalVariable.FILTER_ROWS.title_value) == false
            ) {
              return false;
            }
          } else if (
            this.$globalVariable.FILTER_ROWS.title_option == "Does not contains"
          ) {
            if (
              detail_Name.includes(this.$globalVariable.FILTER_ROWS.title_value) == true
            ) {
              return false;
            }
          }
        }
        // ------------------------------------------- End check title -----------------------------------------------

        console.log("[ComponentFilterRows] (ModuleFilterRows) Check description");
        //--------------------------------------------- Check Description --------------------------------------------
        if (this.$globalVariable.FILTER_ROWS.description != "") {
          if (
            detail_description.indexOf(this.$globalVariable.FILTER_ROWS.description) ===
            -1
          ) {
            return false;
          }
        }
        1;
        //--------------------------------------------- End Check Description ----------------------------------------
        console.log("[ComponentFilterRows] (ModuleFilterRows) Check document number");
        //--------------------------------------------- Check Document Number --------------------------------------------
        if (this.$globalVariable.FILTER_ROWS.document_number != "") {
          if (
            detail_document_number.indexOf(
              this.$globalVariable.FILTER_ROWS.document_number
            ) === -1
          ) {
            return false;
          }
        }
        //--------------------------------------------- End Check Document Number ----------------------------------------

        console.log("[ComponentFilterRows] (ModuleFilterRows) Check status");
        // ------------------------------------------- Check status --------------------------------------------------
        let read_only = true;
        if (this.$globalVariable.FILTER_ROWS.status == "Ready") {
          read_only = false;
        }
        if (read_only != detail_IsReadOnly) {
          return false;
        }
        // ------------------------------------------- End check status ----------------------------------------------

        console.log("[ComponentFilterRows] (ModuleFilterRows) Check last check-in");
        // ------------------------------------------- Check last check-in -------------------------------------------
        if (this.$globalVariable.FILTER_ROWS.last_check_in != "") {
          if (this.$globalVariable.FILTER_ROWS.last_check_in != detail_LastAccessTime) {
            console.log(
              "[ComponentFilterRows] (ModuleFilterRows) Check last check-in failed: ",
              this.$globalVariable.FILTER_ROWS.last_check_in
            );
            return false;
          }
        }
        // ------------------------------------------- End check last check-in ---------------------------------------

        console.log("[ComponentFilterRows] (ModuleFilterRows) Check size");
        // ------------------------------------------- Check size ----------------------------------------------------
        let size_from = 0;
        let size_to = 0;

        if (this.$globalVariable.FILTER_ROWS.size_from_value != "") {
          size_from = this.$globalVariable.FILTER_ROWS.size_from_value;
          if (this.$globalVariable.FILTER_ROWS.size_from_option == "KB") {
            size_from = size_from * 1024;
          } else if (this.$globalVariable.FILTER_ROWS.size_from_option == "MB") {
            size_from = size_from * 1024 * 1024;
          } else if (this.$globalVariable.FILTER_ROWS.size_from_option == "GB") {
            size_from = size_from * 1024 * 1024 * 1024;
          } else if (this.$globalVariable.FILTER_ROWS.size_from_option == "TB") {
            size_from = size_from * 1024 * 1024 * 1024 * 1024;
          }
        }

        if (this.$globalVariable.FILTER_ROWS.size_to_value != "") {
          size_to = this.$globalVariable.FILTER_ROWS.size_to_value;
          if (this.$globalVariable.FILTER_ROWS.size_to_option == "KB") {
            size_to = size_to * 1024;
          } else if (this.$globalVariable.FILTER_ROWS.size_to_option == "MB") {
            size_to = size_to * 1024 * 1024;
          } else if (this.$globalVariable.FILTER_ROWS.size_to_option == "GB") {
            size_to = size_to * 1024 * 1024 * 1024;
          } else if (this.$globalVariable.FILTER_ROWS.size_to_option == "TB") {
            size_to = size_to * 1024 * 1024 * 1024 * 1024;
          }
        }
        console.log("[ComponentFilterRows] (ModuleFilterRows) size_from: ", size_from);
        console.log("[ComponentFilterRows] (ModuleFilterRows) size_to: ", size_to);
        console.log(
          "[ComponentFilterRows] (ModuleFilterRows) detail_Size: ",
          detail_Size
        );

        if (size_from != 0 || size_to != 0) {
          if (size_from <= size_to) {
            if (size_from > detail_Size || detail_Size > size_to) {
              console.log("[ComponentFilterRows] (ModuleFilterRows) Check size failed");
              return false;
            }
          }
        }

        // ------------------------------------------- End check size ------------------------------------------------

        console.log("[ComponentFilterRows] (ModuleFilterRows) Check PASSED");
        return true;
      }
      return true;
    },
    HandleReloadDataAfterDropFiles() {
      const jsonData = {
        name: this.$globalVariable.DIR_SELECTED,
        path: this.$globalVariable.DIR_SELECTED,
        userID: this.$globalVariable.USER_INFO.userID,
        jobID: this.$globalVariable.USER_INFO.jobID,
        areaID: this.$globalVariable.USER_INFO.areaID,
      };

      const jsonString = JSON.stringify(jsonData);
      console.log("[handleDropFile] jsonString: ", jsonString);
      axios
        .post(
          this.$globalVariable.URL_API + "/Files/reload_data_drop_files/",
          jsonString,
          {
            headers: {
              "Content-Type": "application/json",
            },
          }
        )
        .then((response) => {
          console.log("[handleDropFile] response: ", response.data);
          this.processResponseDropFiles(response.data);
        })
        .catch((error) => {
          console.error("[handleDropFile] error: ", error);
        });
    },
    handleDragLeave(event) {
      event.preventDefault();
      this.isDragging = false;
      console.log("Event Drag Leave");
    },
    handleDropDisable(event) {
      event.preventDefault();
      this.isDragging = false;
      console.log("Event Drop");
    },
    handleDragoverDisable(event) {
      event.preventDefault();
      this.isDragging = true;
      console.log("Event Dragover");
    },
    HandleChangeTabName(tabName) {
      const tabNameTmp = tabName;
      this.tabCheckLanguage = tabName;
      console.log(this.formatDate(), "this.tabCheckLanguage: ", this.tabCheckLanguage);
      console.log(this.formatDate(), "HandleChangeTabName:", tabName);
      this.$globalVariable.TAB_CURRENT = tabName;
      console.log(
        this.formatDate(),
        "HandleChangeTabName this.$globalVariable.TAB_CURRENT:",
        this.$globalVariable.TAB_CURRENT
      );

      console.log("(HandleChangeTabName) List File: ", this.listFiles);
      console.log("(HandleChangeTabName) List File Search: ", this.listFilesSearch);
      // console.log(
      //   "[HandleChangeTabName] this.$globalVariable.keySearch: ",
      //   this.$globalVariable.keySearch
      // );
      // if (this.$globalVariable.keySearch == false) {

      // }
      this.listFiles = [];
      this.numberOfView = 0;

      if (tabNameTmp == this.$globalVariable.TAB_DOCUMENTS) {
        this.checkTab = false;
        console.log(this.formatDate(), "HandleChangeTabName => Tab Documents");
        this.$globalVariable.TITLE_NUMBER_OF_FILE = this.$t("TITLE_NUMBER_OF_FILE");
        console.log(
          this.formatDate(),
          "HandleChangeTabName TITLE_NUMBER_OF_FILES: ",
          this.$globalVariable.TITLE_NUMBER_OF_FILE
        );
        this.processLoadDataTabName(this.$globalVariable.TAB_DOCUMENTS);
        this.numberOfView = this.listFiles.length;
      } else if (tabNameTmp == this.$globalVariable.TAB_IMAGES) {
        this.checkTab = false;
        this.$globalVariable.TITLE_NUMBER_OF_FILE = this.$t("TITLE_NUMBER_OF_IMAGES");
        console.log(
          this.formatDate(),
          "HandleChangeTabName TITLE_NUMBER_OF_IMAGES: ",
          this.$globalVariable.TITLE_NUMBER_OF_FILE
        );
        console.log(this.formatDate(), "HandleChangeTabName => Tab Images");
        this.processLoadDataTabName(this.$globalVariable.TAB_IMAGES);

        this.numberOfView = this.listFiles.length;
      } else if (tabNameTmp == this.$globalVariable.TAB_FOLDERS) {
        this.checkTab = true;
        console.log("[HandleChangeTabName] Check Tab: ", this.checkTab);
        this.$globalVariable.TITLE_NUMBER_OF_FILE = this.$t("TITLE_NUMBER_OF_FOLDERS");
        console.log(
          this.formatDate(),
          "HandleChangeTabName TITLE_NUMBER_OF_FOLDERS: ",
          this.$globalVariable.TITLE_NUMBER_OF_FILE
        );
        console.log(this.formatDate(), "HandleChangeTabName => Tab Folders");
        this.processLoadDataTabName(this.$globalVariable.TAB_FOLDERS);
        this.numberOfView = this.listFiles.length;
      } else if (tabNameTmp == this.$globalVariable.TAB_RIGHT_ROLES) {
        this.$globalVariable.TITLE_NUMBER_OF_FILE = "Number of Documents";
        console.log(this.formatDate(), "HandleChangeTabName => Tab Right & Roles");
        this.numberOfView = this.listRightAndRoles.length;
      } else if (tabNameTmp == this.$globalVariable.TAB_GENERAL) {
        this.$globalVariable.TITLE_NUMBER_OF_FILE = "Number of Documents";
        console.log(this.formatDate(), "HandleChangeTabName => Tab Tree");
      } else if (tabNameTmp == this.$globalVariable.TAB_HISTORY) {
        this.$globalVariable.TITLE_NUMBER_OF_FILE = "Number of Documents";
        console.log(this.formatDate(), "HandleChangeTabName => Tab History");
      } else {
        this.$globalVariable.TITLE_NUMBER_OF_FILE = "Number of Documents";
        console.log(this.formatDate(), "HandleChangeTabName => Unknown Tab");
      }
    },
    processLoadDataTabName(tabName) {
      console.log(this.formatDate(), "processLoadDataTabName => tabName: ", tabName);
      try {
        const jsonString = this.dataOriginal;
        const JsonStringSearch = this.listFilesSearch;
        console.log("[processLoadDataTabName]  jsonString: ", jsonString);
        console.log(
          "(processLoadDataTabName) JsonString Search Length: ",
          JsonStringSearch.length
        );

        var idResponse = jsonString.id;

        this.sizeAllFiles = jsonString.sizeAllFiles;
        this.listFiles = [];
        let totalSize = 0;
        var childrenReponse = [];
        if (JsonStringSearch.length == 0) {
          for (let i = 0; i < jsonString.dataDirectories.length; i++) {
            const directory = jsonString.dataDirectories[i];
            const Name = directory["Name"];
            const FullName = directory["FullName"];
            const CreationTime = directory["CreationTime"];
            const LastAccessTime = directory["LastAccessTime"];
            const LastWriteTime = directory["LastWriteTime"];
            const bookmark = directory["bookmark"];
            const isExpanded = directory["isExpanded"];
            const tabSelected = directory["tabSelected"];

            var data = {
              id: this.lastIdTree++,
              name: Name,
              fullName: FullName,
              bookmark: bookmark,
              isExpanded: isExpanded,
              isTabFavorites: false,
              tabSelected: tabSelected,
              children: [],
            };

            if (tabName == this.$globalVariable.TAB_FOLDERS) {
              this.checkTab = true;
              console.log("[processLoadDataTabName] Check Tab: ", this.checkTab);
              var dataDirectory = {
                id: i,
                Name: Name,
                FullName: FullName,
                LastWriteTime: LastWriteTime,
                CreationTime: CreationTime,
                DirectoryName: "",
                Extension: ".directory",
                IsReadOnly: false,
                LastAccessTime: LastAccessTime,
                Length: "",
              };
              this.listFiles.push(dataDirectory);
            }
            console.log("[processLoadDataTabName] listFiles: ", this.listFiles);

            childrenReponse.push(data);
            console.log("[processLoadDataTabName] childrenReponse: ", childrenReponse);
          }
        }

        if (JsonStringSearch.length > 0) {
          const JsonStringSearchFor = JsonStringSearch[0].dataFiles;
          for (let i = 0; i < JsonStringSearchFor.length; i++) {
            const file = JsonStringSearchFor[i];
            const FullName = file["Name"];
            const Data = file["Data"];
            const detail_Name = Data["Name"];
            const detail_LastWriteTime = Data["LastWriteTime"];
            const detail_CreationTime = Data["CreationTime"];
            const detail_DirectoryName = Data["DirectoryName"];
            const detail_Extension = Data["Extension"];
            const detail_IsReadOnly = Data["IsReadOnly"] === true;
            const detail_LastAccessTime = Data["LastAccessTime"];
            const detail_Length = Data["Length"];
            const detail_Size = Data["Size"];
            const bookmark = Data["bookmark"];
            const detail_revision = Data["revision"];
            const detail_description = Data["description"];
            const detail_document_number = Data["document_number"];
            const detail_language = Data["language"];
            const detail_sheet = Data["sheet"];
            const detail_status = Data["status"];

            if (this.ModuleFilterRows(file) == false) {
              continue;
            }

            totalSize += detail_Size;

            var dataFileSearch = {
              id: i,
              Name: detail_Name,
              FullName: FullName,
              LastWriteTime: detail_LastWriteTime,
              CreationTime: detail_CreationTime,
              DirectoryName: detail_DirectoryName,
              Extension: detail_Extension,
              IsReadOnly: detail_IsReadOnly,
              LastAccessTime: detail_LastAccessTime,
              Length: detail_Length,
              bookmark: bookmark,
              Revision: detail_revision,
              Description: detail_description,
              DocumentNumber: detail_document_number,
              Language: detail_language,
              Sheet: detail_sheet,
              Status: detail_status,
            };
            this.listFiles.push(dataFileSearch);
          }
        } else {
          for (let i = 0; i < jsonString.dataFiles.length; i++) {
            const file = jsonString.dataFiles[i];
            const FullName = file["Name"];
            const Data = file["Data"];
            const detail_Name = Data["Name"];
            const detail_LastWriteTime = Data["LastWriteTime"];
            const detail_CreationTime = Data["CreationTime"];
            const detail_DirectoryName = Data["DirectoryName"];
            const detail_Extension = Data["Extension"];
            const detail_IsReadOnly = Data["IsReadOnly"] === true;
            const detail_LastAccessTime = Data["LastAccessTime"];
            const detail_Length = Data["Length"];
            const detail_Size = Data["Size"];
            const bookmark = Data["bookmark"];
            const detail_revision = Data["revision"];
            const detail_description = Data["description"];
            const detail_document_number = Data["document_number"];
            const detail_language = Data["language"];
            const detail_sheet = Data["sheet"];
            const detail_status = Data["status"];

            if (tabName == this.$globalVariable.TAB_DOCUMENTS) {
              if (
                detail_Extension.includes(".png") ||
                detail_Extension.includes(".jpg") ||
                detail_Extension.includes(".jpge")
              ) {
                continue;
              }
            } else if (tabName == this.$globalVariable.TAB_IMAGES) {
              if (
                detail_Extension.includes(".png") ||
                detail_Extension.includes(".jpg") ||
                detail_Extension.includes(".jpge")
              ) {
                console.log("this file image");
              } else {
                continue;
              }
            } else {
              continue;
            }

            if (this.ModuleFilterRows(file) == false) {
              continue;
            }

            totalSize += detail_Size;

            var dataFile = {
              id: i,
              Name: detail_Name,
              FullName: FullName,
              LastWriteTime: detail_LastWriteTime,
              CreationTime: detail_CreationTime,
              DirectoryName: detail_DirectoryName,
              Extension: detail_Extension,
              IsReadOnly: detail_IsReadOnly,
              LastAccessTime: detail_LastAccessTime,
              Length: detail_Length,
              bookmark: bookmark,
              Revision: detail_revision,
              Description: detail_description,
              DocumentNumber: detail_document_number,
              Language: detail_language,
              Sheet: detail_sheet,
              Status: detail_status,
            };
            console.log("(processLoadDataTabName) dataFile: ", dataFile);
            this.listFiles.push(dataFile);
          }
        }
        // console.log("childrenReponse: ", childrenReponse);
        // console.log("listFiles: ", this.listFiles);
        // console.log("totalSize: ", totalSize);
        this.sizeAllFiles = this.convertSize(totalSize);
        if (tabName == this.$globalVariable.TAB_FOLDERS) {
          this.sizeAllFiles = jsonString.sizeAllFiles;
        }

        // console.log("checking tree current");
        // console.log("list tree current: ", this.tree.length);
        for (let i = 0; i < this.tree.length; i++) {
          // console.log("tree index: ", i);
          const treeItem = this.tree[i];
          const id = treeItem.id;
          // const Name = treeItem.name;
          // const FullName = treeItem.fullName;
          // const children = treeItem.children.length;

          // console.log("\t id: ", id);
          // console.log("\t Name: ", Name);
          // console.log("\t FullName: ", FullName);
          // console.log("\t children: ", children);

          if (idResponse == id) {
            // console.log("\t =========> Found");
            treeItem.children = childrenReponse;
            console.log(
              "[processLoadDataTabName] treeItem.children: ",
              treeItem.children
            );

            // console.log("tree: ", this.tree);
          } else {
            this.showTreeChildren(treeItem, childrenReponse, idResponse);
            // console.log("tree: ", this.tree);
          }
        }
        console.log(this.formatDate(), "checking tree current completed...");
        console.log(this.formatDate(), "tree: ", this.tree);
      } catch (error) {
        console.log(this.formatDate(), "error: ", error);
      }
    },
    convertSize(Length) {
      let result = "";
      const kilobyte = 1024;
      const megabyte = 1024 * 1024;
      const gigabyte = 1024 * 1024 * 1024;

      if (Length >= gigabyte) {
        let number = Length / gigabyte;
        let roundNumber = number.toFixed(2);
        result = roundNumber + " GB";
      } else if (Length >= megabyte) {
        let number = Length / megabyte;
        let roundNumber = number.toFixed(2);
        result = roundNumber + " MB";
      } else {
        let number = Length / kilobyte;
        let roundNumber = number.toFixed(2);
        result = roundNumber + " KB";
      }
      console.log(this.formatDate(), "[convertSize] ", Length, " byte => ", result);
      return result;
    },
    HandleLogout() {
      console.log("Logout");
      // Khi người dùng đăng nhập hoặc thay đổi trạng thái ứng dụng
      const appState = {
        isLoggedIn: false, // Thay đổi dựa trên trạng thái đăng nhập
        userID: this.$globalVariable.USER_INFO.userID,
      };

      // Lưu trạng thái vào sessionStorage hoặc localStorage
      window.sessionStorage.setItem("ManagerDrawState", JSON.stringify(appState));
      this.isLoginSuccess = true;
    },
    HandleActionHome() {},
    HandleActionVersion() {
      this.isActiveFormRelease = true;
    },
    HandleActionHelp() {
      console.log("(HandleActionHelp) Click Handle Success");
      const fileName = "Help.pdf";

      const jsonData = {
        userID: this.$globalVariable.USER_INFO.userID,
        fileName: fileName,
      };

      const jsonString = JSON.stringify(jsonData);
      console.log("(HandleActionHelp) Json String: ", jsonString);

      axios
        .post(
          this.$globalVariable.URL_API + "/WeatherForecast/open_file_help",
          jsonString,
          {
            headers: {
              "Content-Type": "application/json",
            },
            responseType: "blob",
          }
        )
        .then((response) => {
          console.log("(HandleActionHelp) Response Data: ", response);
          const file = new Blob([response.data], {
            type: "application/pdf",
          });
          const fileURL = URL.createObjectURL(file);
          console.log("(HandleActionHelp) File URL: ", fileURL);

          const newTab = window.open(fileURL, "_blank");
          newTab.location.href = fileName;
          newTab.onload = function () {
            newTab.document.write(`<html><head><title>${fileName}</title></head></html>`);
            newTab.document.body.innerHTML = `<embed src="${fileURL}" type="application/pdf" width="100%"" height="100%" />`;
            newTab.document.close();
          };
        })
        .catch((error) => {
          console.error("(HandleActionHelp) Error: ", error);
        });
    },
    HandleActionHotline() {
      this.isActiveFormHotline = true;
    },
    mapJobPositionChangeLanguage(JobID) {
      let oldJobPosition = "";
      switch (JobID) {
        case 1:
          oldJobPosition = this.$t("DirectorDeputyDirector");
          break;
        case 2:
          oldJobPosition = this.$t("ForemanDeputyForeman");
          break;
        case 3:
          oldJobPosition = this.$t("InCharge");
          break;
        case 4:
          oldJobPosition = this.$t("Technician");
          break;
        case 5:
          oldJobPosition = this.$t("Operate");
          break;
        case 6:
          oldJobPosition = this.$t("Employee");
          break;
        default:
          oldJobPosition = "";
      }
      return oldJobPosition;
    },
    mapAreaChangeLanguage(areaID) {
      let oldArea = "";
      switch (areaID) {
        case 1:
          oldArea = this.$t("PXTSC");
          break;
        case 2:
          oldArea = this.$t("PXHSM");
          break;
        case 3:
          oldArea = this.$t("FurnaceArea");
          break;
        case 4:
          oldArea = this.$t("WaterTreatment");
          break;
        case 5:
          oldArea = "VP NM.CT QSP";
          break;
        case 6:
          oldArea = "NM.CT HRC2";
          break;
        default:
          oldArea = "";
      }
      return oldArea;
    },
    HandleIsViewAndTabCheck() {
      if (this.isCheckViewListLayout == true) {
        this.$globalVariable.TEXT_LAYOUT = this.$t("ListLayout");
      } else {
        this.$globalVariable.TEXT_LAYOUT = this.$t("GridLayout");
      }
      if (this.tabCheckLanguage == "tab_documents") {
        this.$globalVariable.TITLE_NUMBER_OF_FILE = this.$t("TITLE_NUMBER_OF_FILE");
      } else if (this.tabCheckLanguage == "tab_images") {
        this.$globalVariable.TITLE_NUMBER_OF_FILE = this.$t("TITLE_NUMBER_OF_IMAGES");
      } else if (this.tabCheckLanguage == "tab_folders") {
        this.$globalVariable.TITLE_NUMBER_OF_FILE = this.$t("TITLE_NUMBER_OF_FOLDERS");
      }
    },
    HandleChangeLanguageJobPosition() {
      this.jobPositionItems[0] = this.$t("DirectorDeputyDirector");
      this.jobPositionItems[1] = this.$t("ForemanDeputyForeman");
      this.jobPositionItems[2] = this.$t("InCharge");
      this.jobPositionItems[3] = this.$t("Technician");
      this.jobPositionItems[4] = this.$t("Operate");
      this.jobPositionItems[5] = this.$t("Employee");
      this.userInfo.jobID = this.$globalVariable.USER_INFO.jobID;
      this.userInfo.jobPosition = this.mapJobPositionChangeLanguage(this.userInfo.jobID);
      console.log(
        "(HandleChangeLanguageJobPosition) jobPositionItems: ",
        this.jobPositionItems
      );
      console.log("(HandleChangeLanguageJobPosition) JobID: ", this.userInfo.jobID);
      console.log(
        "(HandleChangeLanguageJobPosition) jobPosition: ",
        this.userInfo.jobPosition
      );
    },
    HandleChangeLanguageArea() {
      this.areaList[0] = this.$t("PXTSC");
      this.areaList[1] = this.$t("PXHSM");
      this.areaList[2] = this.$t("FurnaceArea");
      this.areaList[3] = this.$t("WaterTreatment");
      this.userInfo.areaID = this.$globalVariable.USER_INFO.areaID;
      this.userInfo.area = this.mapAreaChangeLanguage(this.userInfo.areaID);
      console.log("(HandleChangeLanguageArea) areaList: ", this.areaList);
      console.log("(HandleChangeLanguageArea) areaID: ", this.userInfo.areaID);
      console.log("(HandleChangeLanguageArea) area: ", this.userInfo.area);
    },
    mapLanguageUser(languageID) {
      let ChangeLanguage = "";
      switch (languageID) {
        case 1:
          ChangeLanguage = "English";
          break;
        case 2:
          ChangeLanguage = "VietNamese";
          break;
        default:
          ChangeLanguage = "";
      }
      return ChangeLanguage;
    },
    HandleSettingLanguage() {
      this.dialogFormChangeLanguages = true;
      console.log(
        "(HandleSettingLanguage) This Language User Info:",
        this.$globalVariable.USER_INFO.language
      );
      this.userInfo.language = this.mapLanguageUser(
        this.$globalVariable.USER_INFO.language
      );
      console.log();
      console.log(
        "(HandleSettingLanguage) This Language change:",
        this.userInfo.language
      );
    },
    async HandleChangeLanguage() {
      console.log(
        "(handleChangeLanguage) userID: ",
        this.$globalVariable.USER_INFO.userID
      );
      console.log("(handleChangeLanguage) Language: ", this.userInfo.language);

      let language = "";
      switch (this.userInfo.language) {
        case "English":
          language = 1;
          break;
        case "VietNamese":
          language = 2;
          break;
        default:
          language = 2;
      }
      console.log("(handleChangeLanguage) Change Language ID: ", language);
      const jsonData = {
        userID: this.$globalVariable.USER_INFO.userID,
        language: language,
      };
      const stringJsonDataChangeLanguage = JSON.stringify(jsonData);
      console.log("(handleChangeLanguage) Change Language Json Data: ", jsonData);
      console.log(
        "(handleChangeLanguage) Change Language String Json Data: ",
        stringJsonDataChangeLanguage
      );
      await axios
        .post(
          this.$globalVariable.URL_API + "/ManageAccess/change_language/",
          stringJsonDataChangeLanguage,
          {
            headers: {
              "Content-Type": "application/json",
            },
          }
        )
        .then((response) => {
          console.log(
            "(handleChangeLanguage) Response Data Change Language: ",
            response.data
          );
          if (response.data == "success") {
            this.$globalVariable.USER_INFO.language = jsonData.language;
            console.log(
              "(handleChangeLanguage) Language ID Success: ",
              this.$globalVariable.USER_INFO.language
            );
            this.dialogFormChangeLanguages = false;
            if (this.$globalVariable.USER_INFO.language == 1) {
              this.$i18n.locale = "en";
              this.HandleChangeLanguageJobPosition();
              this.HandleChangeLanguageArea();
              this.HandleIsViewAndTabCheck();
            } else if (this.$globalVariable.USER_INFO.language == 2) {
              this.$i18n.locale = "vi";
              this.$globalVariable.Author = this.$t("Author");
              console.log(
                "(handleChangeLanguage) GlobalVariable Author: ",
                this.$globalVariable.Author
              );
              this.HandleChangeLanguageJobPosition();
              this.HandleChangeLanguageArea();
              this.HandleIsViewAndTabCheck();
            }
            const savedState = window.sessionStorage.getItem("ManagerDrawState");
            const appState = JSON.parse(savedState);
            appState["language"] = this.$globalVariable.USER_INFO.language;
            window.sessionStorage.setItem("ManagerDrawState", JSON.stringify(appState));
          }
        })
        .catch((error) => {
          console.error(error);
        });
    },
    mapJobIDToJobPosition(jobID) {
      let oldJobPosition = "";
      switch (jobID) {
        case 1:
          oldJobPosition = this.$t("DirectorDeputyDirector");
          break;
        case 2:
          oldJobPosition = this.$t("ForemanDeputyForeman");
          break;
        case 3:
          oldJobPosition = this.$t("InCharge");
          break;
        case 4:
          oldJobPosition = this.$t("Technician");
          break;
        case 5:
          oldJobPosition = this.$t("Operate");
          break;
        case 6:
          oldJobPosition = this.$t("Employee");
          break;
        default:
          oldJobPosition = "";
      }
      return oldJobPosition;
    },
    mapAreaIDToArea(areaID) {
      let oldArea = "";
      switch (areaID) {
        case 1:
          oldArea = this.$t("PXTSC");
          break;
        case 2:
          oldArea = this.$t("PXHSM");
          break;
        case 3:
          oldArea = this.$t("FurnaceArea");
          break;
        case 4:
          oldArea = this.$t("WaterTreatment");
          break;
        case 5:
          oldArea = "VP NM.CT QSP";
          break;
        case 6:
          oldArea = "NM.CT HRC2";
          break;
        default:
          oldArea = "";
      }
      return oldArea;
    },
    mapKipIDtoKip(kipID) {
      let oldKip = "";
      switch (kipID) {
        case 1:
          oldKip = "A";
          break;
        case 2:
          oldKip = "B";
          break;
        case 3:
          oldKip = "C";
          break;
        default:
          oldKip = "";
      }
      return oldKip;
    },
    HandleSettingUser() {
      if (this.$globalVariable.USER_INFO.language == 1) {
        this.$i18n.locale = "en";
        this.HandleChangeLanguageJobPosition();
        this.HandleChangeLanguageArea();
      } else if (this.$globalVariable.USER_INFO.language == 2) {
        this.$i18n.locale = "vi";
        this.HandleChangeLanguageJobPosition();
        this.HandleChangeLanguageArea();
      }
      if (this.$globalVariable.USER_INFO.jobID == 100) {
        this.isActiveFormPrivilege = true;
      } else {
        this.userInfo.fullName = this.$globalVariable.USER_INFO.fullName;
        this.userInfo.userID = this.$globalVariable.USER_INFO.userID;
        this.userInfo.jobID = this.$globalVariable.USER_INFO.jobID;
        this.userInfo.jobPosition = this.mapJobIDToJobPosition(this.userInfo.jobID);
        this.userInfo.areaID = this.$globalVariable.USER_INFO.areaID;
        this.userInfo.area = this.mapAreaIDToArea(this.userInfo.areaID);
        this.userInfo.workID = this.$globalVariable.USER_INFO.workID;
        this.userInfo.gioLam = this.userInfo.workID;
        this.userInfo.gioLam = `${this.userInfo.gioLam}`;
        this.userInfo.kipID = this.$globalVariable.USER_INFO.kipID;
        this.userInfo.kip = this.mapKipIDtoKip(this.userInfo.kipID);
        this.userInfo.email = this.$globalVariable.USER_INFO.email;
        console.log("fullName Profile: ", this.userInfo.fullName);
        console.log("Email Profile: ", this.userInfo.email);
        console.log("Kip: ", this.userInfo.kip);
        console.log("this.userInfo.kipID: ", this.userInfo.kipID);
        console.log("Gio Lam: ", this.userInfo.gioLam);
        console.log("Work ID Profile: ", this.userInfo.workID);
        console.log("jobPosition: ", this.userInfo.jobPosition);
        console.log("JobID: ", this.jobPositionItems);
        console.log("area: ", this.userInfo.area);
        this.dialog = true;
        this.showSnackbar = false;
        this.oldUserInfoArray = this.$globalVariable.USER_INFO;
      }
    },
    async handleChangeProfile() {
      console.log("(handleChangeProfile) FullName Profile: ", this.userInfo.fullName);
      console.log("(handleChangeProfile) UserID Profile: ", this.userInfo.userID);
      console.log("(handleChangeProfile) Email Profile: ", this.userInfo.email);
      console.log("(handleChangeProfile) Job Position: ", this.userInfo.jobPosition);
      console.log("(handleChangeProfile) Kip Profile: ", this.userInfo.kip);
      console.log("(handleChangeProfile) Work Place: ", this.userInfo.area);
      console.log("(handleChangeProfile) Gio Lam: ", this.userInfo.gioLam);
      console.log("(handleChangeProfile) oldUserInfoArray: ", this.oldUserInfoArray);
      console.log("(handleChangeProfile) JobID Profile: ", this.userInfo.jobID);

      let jobID = 0;
      switch (this.userInfo.jobPosition) {
        case this.$t("DirectorDeputyDirector"):
          jobID = 1;
          break;
        case this.$t("ForemanDeputyForeman"):
          jobID = 2;
          break;
        case this.$t("InCharge"):
          jobID = 3;
          break;
        case this.$t("Technician"):
          jobID = 4;
          break;
        case this.$t("Operate"):
          jobID = 5;
          break;
        case this.$t("Employee"):
          jobID = 6;
          break;
        default:
          jobID = 0;
      }

      let areaID = 0;
      switch (this.userInfo.area) {
        case this.$t("PXTSC"):
          areaID = 1;
          break;
        case this.$t("PXHSM"):
          areaID = 2;
          break;
        case this.$t("FurnaceArea"):
          areaID = 3;
          break;
        case this.$t("WaterTreatment"):
          areaID = 4;
          break;
        case "VP NM.CT QSP":
          areaID = 5;
          break;
        case "NM.CT HRC2":
          areaID = 6;
          break;
        default:
          areaID = 0;
      }

      let kipID = 0;
      switch (this.userInfo.kip) {
        case "A":
          kipID = 1;
          break;
        case "B":
          kipID = 2;
          break;
        case "C":
          kipID = 3;
          break;
        default:
          kipID = 0;
      }
      if (this.userInfo.fullName == "" || this.userInfo.email == "") {
        this.message = this.$t("FieldsBlank");
        this.snackbarColor = "red";
        this.showSnackbar = true;
      } else {
        if (
          this.oldUserInfoArray.fullName == this.userInfo.fullName &&
          this.oldUserInfoArray.jobID == jobID &&
          this.oldUserInfoArray.areaID == areaID &&
          this.oldUserInfoArray.workID == this.userInfo.gioLam &&
          this.oldUserInfoArray.kipID == kipID &&
          this.oldUserInfoArray.email == this.userInfo.email
        ) {
          this.message = this.$t("NoChangeInformation");
          this.snackbarColor = "#f1cd1e";
          this.showSnackbar = true;
        } else {
          console.log("(handleChangeProfile) userID: ", this.userInfo.userID);
          console.log("(handleChangeProfile) email: ", this.userInfo.email);
          console.log("(handleChangeProfile) areaID: ", areaID);
          console.log("(handleChangeProfile) jobID: ", jobID);
          console.log("(handleChangeProfile) kipID: ", kipID);
          console.log(
            "(handleChangeProfile) this.userInfo.jobPosition: ",
            parseInt(this.userInfo.gioLam)
          );
          if (parseInt(this.userInfo.gioLam) === 1) {
            kipID = 1;
          }
          const jsonData = {
            fullName: this.userInfo.fullName,
            userID: this.userInfo.userID,
            email: this.userInfo.email,
            jobID: jobID,
            kipID: kipID,
            workID: parseInt(this.userInfo.gioLam),
            areaID: areaID,
          };

          const jsonString = JSON.stringify(jsonData);
          console.log("(handleChangeProfile) Json Data Change Profile: ", jsonData);
          console.log("(handleChangeProfile) Json String Change Profile: ", jsonString);

          await axios
            .post(
              this.$globalVariable.URL_API + "/ManageAccess/change_profile/",
              jsonString,
              {
                headers: {
                  "Content-Type": "application/json",
                },
              }
            )
            .then((response) => {
              console.log("Response Data Change Profile: ", response);
              console.log("Thay đổi thành công");
              if (response.data == "success") {
                this.$globalVariable.USER_INFO.jobID = jsonData.jobID;
                this.$globalVariable.USER_INFO.areaID = jsonData.areaID;
                this.$globalVariable.USER_INFO.workID = jsonData.workID;
                this.$globalVariable.USER_INFO.kipID = jsonData.kipID;
                this.$globalVariable.USER_INFO.fullName = jsonData.fullName;
                this.$globalVariable.USER_INFO.email = jsonData.email;
                this.$forceUpdate();
                this.userInfo.gioLam = this.$globalVariable.USER_INFO.workID;
                this.userInfo.gioLam = `${this.userInfo.gioLam}`;
                this.userInfo.jobPosition = this.mapJobIDToJobPosition(
                  this.$globalVariable.USER_INFO.jobID
                );
                this.userInfo.area = this.mapAreaIDToArea(
                  this.$globalVariable.USER_INFO.areaID
                );
                this.userInfo.kip = this.mapKipIDtoKip(
                  this.$globalVariable.USER_INFO.kipID
                );
                this.userInfo.email = this.$globalVariable.USER_INFO.email;
                console.log(
                  "(handleChangeProfile) fullName success: ",
                  this.$globalVariable.USER_INFO.fullName
                );
                console.log(
                  "(handleChangeProfile) jobPosition success: ",
                  this.userInfo.jobPosition
                );
                console.log("(handleChangeProfile) Kip success:  ", this.userInfo.kip);
                console.log(
                  "(handleChangeProfile) Gio Lam success : ",
                  this.userInfo.gioLam
                );
                console.log("(handleChangeProfile) Area success : ", this.userInfo.area);
                console.log(
                  "(handleChangeProfile) Email success : ",
                  this.userInfo.email
                );
                this.dialog = false;
              }
            })
            .catch((error) => {
              console.error(error);
            });
        }
      }
    },
    handleDialogFormChangePass() {
      this.userInfo.password = "";
      this.userInfo.newPassword = "";
      this.userInfo.confirmPassword = "";
      this.dialog = false;
      this.dialogFormChangePass = true;
      this.showSnackbar = false;
      this.apiError = false;
    },
    async handleChangePassword() {
      console.log("(HandleChangePassword) User ID: ", this.userInfo.userID);
      console.log("(HandleChangePassword) Password: ", this.userInfo.password);
      console.log("(HandleChangePassword) Password: ", this.userInfo.password);
      console.log("(HandleChangePassword) New Password: ", this.userInfo.newPassword);
      console.log(
        "(HandleChangePassword) Confirm Password: ",
        this.userInfo.confirmPassword
      );

      const jsonDataChangePassword = {
        userID: this.userInfo.userID,
        password: this.userInfo.password,
        newPassword: this.userInfo.newPassword,
        confirmPassword: this.userInfo.confirmPassword,
      };

      if (
        jsonDataChangePassword.password === "" ||
        jsonDataChangePassword.newPassword === "" ||
        jsonDataChangePassword.confirmPassword === ""
      ) {
        this.message = this.$t("FieldsBlank");
        this.snackbarColor = "red";
        this.showSnackbar = true;
      } else if (jsonDataChangePassword.password == jsonDataChangePassword.newPassword) {
        this.message = this.$t("SameNewAndOldPassword");
        this.snackbarColor = "#f1cd1e";
        this.showSnackbar = true;
      } else {
        const stringJsonDataChangePassword = JSON.stringify(jsonDataChangePassword);
        console.log(
          "(HandleChangePassword) Json Data Change Password: ",
          jsonDataChangePassword
        );
        console.log(
          "(HandleChangePassword) Json String Data Change Password: ",
          stringJsonDataChangePassword
        );

        await axios
          .post(
            this.$globalVariable.URL_API + "/ManageAccess/change_password/",
            stringJsonDataChangePassword,
            {
              headers: {
                "Content-Type": "application/json",
              },
            }
          )
          .then((response) => {
            if (response.data == "success") {
              this.apiError = true;
              console.log("(HandleChangePassword) this.apiError:", this.apiError);
              console.log("(HandleChangePassword) Response Success: ", response);
              this.userInfo.password = "";
              this.userInfo.newPassword = "";
              this.userInfo.confirmPassword = "";
              this.dialogFormChangePass = false;
            } else {
              this.message = "Mật khẩu đã sai";
              this.snackbarColor = "red";
              this.showSnackbar = true;
            }
          })
          .catch((error) => {
            console.error(error);
          });
      }
    },
    handleFolderSelect(event) {
      console.log("[handleFolderSelect] target: ", event.target.files);
    },
    HandleBrowse() {
      console.log("Click button Browse");
    },
    HandleFavorites() {
      console.log("Click button Favorites");
    },
    HandleHome() {
      console.log("Click button Home");
    },
    toggleActiveBrowseDirectory() {
      if (
        this.isActiveBrowseDirectory ||
        this.active_icon_loading_home ||
        this.active_icon_loading_favorites
      ) {
        console.log(this.formatDate(), "(toggleActive) Browse is using");
      } else {
        this.$globalVariable.PAGE_CURRENT = "browse";

        const myDiv = this.$refs.contentDivDirectory;
        const divHeight = myDiv.clientHeight / 2;
        this.divHeightTreeNodeBrowse = "+" + divHeight + "px";
        this.divHeightTreeNodeDirectory = "calc(100% - " + divHeight + "px)";
        this.divBorderRadiusBottomLeftTreeNodeDirectory = "0px";
        this.divBorderRadiusBottomRightTreeNodeDirectory = "0px";

        this.active_icon_loading_browse = true;
        this.isActiveBrowseDirectory = true;
        this.isActiveFavovitesDirectory = false;
        this.isActiveHomeDirectory = false;
        this.active_icon_loading_browse = false;
        this.fullPathDirectoryBrowseBefore = "/";
        this.fullPathDirectoryBrowseAfter = "/";
      }
    },
    async toggleActiveFavovitesDirectory() {
      if (this.isActiveFavovitesDirectory || this.active_icon_loading_home) {
        console.log(this.formatDate(), "(toggleActive) Favorites is using");
      } else {
        this.$globalVariable.PAGE_CURRENT = "favorites";
        this.divHeightTreeNodeDirectory = "calc(100%)";
        this.divBorderRadiusBottomLeftTreeNodeDirectory = "6px";
        this.divBorderRadiusBottomRightTreeNodeDirectory = "6px";
        this.active_icon_loading_favorites = true;
        this.isActiveFavovitesDirectory = true;
        this.isActiveBrowseDirectory = false;
        this.isActiveHomeDirectory = false;
        this.tree = [];
        this.treeBrowse = [];
        this.directorySelected = "/";
        this.fullPathDirectorySelected = "/";
        this.fullPathDirectory = "/";
        this.isClickItemTreeNode = false;

        const jsonData = {
          user_id: this.$globalVariable.USER_INFO.userID,
        };

        const jsonString = JSON.stringify(jsonData);
        console.log(
          this.formatDate(),
          "(toggleActiveFavovitesDirectory) jsonString:",
          jsonString
        );

        await axios
          .post(this.$globalVariable.URL_API + "/Option/request_favorites", jsonString, {
            headers: {
              "Content-Type": "application/json",
            },
          })
          .then((response) => {
            console.log(
              this.formatDate(),
              "(toggleActiveFavovitesDirectory) response:",
              response.data
            );
            const jsonString = response.data;
            console.log(this.formatDate(), "user_id: ", jsonString.user_id);
            console.log(this.formatDate(), "data: ", jsonString.data_directory.length);

            this.tree = [];
            this.lastIdTree = 1;
            this.dataOriginal = jsonString.data_file;
            this.listFiles = [];

            for (let i = 0; i < jsonString.data_directory.length; i++) {
              const directory = jsonString.data_directory[i];
              const name = directory["name"];
              const location = directory["location"];
              const type = directory["type"];
              const isExpanded = directory["isExpanded"];
              const tabSelected = directory["tabSelected"];

              if (type == 0) {
                var data = {
                  id: this.lastIdTree++,
                  name: name,
                  fullName: location,
                  bookmark: true,
                  isExpanded: isExpanded,
                  isTabFavorites: tabSelected == 2 ? true : false,
                  tabSelected: tabSelected,
                  children: [],
                };
                this.tree.push(data);
              }
            }

            console.log(
              this.formatDate(),
              "(toggleActiveFavovitesDirectory) tree:",
              this.tree
            );
            console.log(
              this.formatDate(),
              "(toggleActiveFavovitesDirectory) listFiles:",
              this.listFiles
            );
            this.HandleChangeTabName(this.$globalVariable.TAB_CURRENT);
            this.active_icon_loading_favorites = false;
          })
          .catch((error) => {
            console.error(
              this.formatDate(),
              "(toggleActiveFavovitesDirectory) error:",
              error
            );
          });
      }
    },
    async toggleActiveHomeDirectory() {
      if (this.isActiveHomeDirectory || this.active_icon_loading_favorites) {
        console.log(this.formatDate(), "(toggleActive) Home is using");
      } else {
        this.$globalVariable.PAGE_CURRENT = "home";
        this.divHeightTreeNodeDirectory = "calc(100%)";
        this.divBorderRadiusBottomLeftTreeNodeDirectory = "6px";
        this.divBorderRadiusBottomRightTreeNodeDirectory = "6px";
        this.active_icon_loading_home = true;
        this.isActiveHomeDirectory = true;
        this.isActiveBrowseDirectory = false;
        this.isActiveFavovitesDirectory = false;
        this.tree = [];
        this.treeBrowse = [];
        this.fullPathDirectory = "/";

        const apiUrl = this.$globalVariable.URL_API + "/Files/get_drive_info/";
        console.log(this.formatDate(), "(toggleActiveHomeDirectory) apiUrl: ", apiUrl);

        var path_data = "E:\\Drive_W\\Data";
        if (this.$globalVariable.RUNNING_DOCKER) {
          path_data = "/Data/Data";
        }

        const jsonData = {
          path: path_data,
          userID: this.$globalVariable.USER_INFO.userID,
          jobID: this.$globalVariable.USER_INFO.jobID,
          areaID: this.$globalVariable.USER_INFO.areaID,
          admin: this.$globalVariable.USER_INFO.admin,
        };

        const jsonString = JSON.stringify(jsonData);
        console.log(
          this.formatDate(),
          "(toggleActiveHomeDirectory) jsonData: ",
          jsonData
        );
        console.log(
          this.formatDate(),
          "(toggleActiveHomeDirectory) jsonString: ",
          jsonString
        );

        await axios
          .post(apiUrl, jsonString, {
            headers: {
              "Content-Type": "application/json",
            },
          })
          .then((response) => {
            this.processResponseDriveInfo(response.data);
          })
          .catch((error) => {
            console.error(this.formatDate(), "error: ", error);
          });
        this.active_icon_loading_home = false;
      }
    },
    HandleOpenPrivilege() {
      if (this.$globalVariable.USER_INFO.jobID == 100) {
        this.isActiveFormPrivilege = true;
      }
    },
    HandleCloseFormPrivilege() {
      this.isActiveFormPrivilege = false;
    },
    HandleCloseFormHotline() {
      this.isActiveFormHotline = false;
    },
    HandleCloseFormRelease() {
      this.isActiveFormRelease = false;
    },
    async HandleLoginSuccess(params) {
      const { username } = params;
      console.log(this.formatDate(), "(HandleLoginSuccess) username: ", username);
      console.log(this.formatDate(), "(HandleLoginSuccess) login passed");

      console.log(
        this.formatDate(),
        "(HandleLoginSuccess) id: ",
        this.$globalVariable.USER_INFO.id
      );
      console.log(
        this.formatDate(),
        "(HandleLoginSuccess) fullName: ",
        this.$globalVariable.USER_INFO.fullName
      );
      console.log(
        this.formatDate(),
        "(HandleLoginSuccess) userID: ",
        this.$globalVariable.USER_INFO.userID
      );
      console.log(
        this.formatDate(),
        "(HandleLoginSuccess) email: ",
        this.$globalVariable.USER_INFO.email
      );
      console.log(
        this.formatDate(),
        "(HandleLoginSuccess) password: ",
        this.$globalVariable.USER_INFO.password
      );
      console.log(
        this.formatDate(),
        "(HandleLoginSuccess) jobID: ",
        this.$globalVariable.USER_INFO.jobID
      );
      console.log(
        this.formatDate(),
        "(HandleLoginSuccess) kipID: ",
        this.$globalVariable.USER_INFO.kipID
      );
      console.log(
        this.formatDate(),
        "(HandleLoginSuccess) workID: ",
        this.$globalVariable.USER_INFO.workID
      );
      console.log(
        this.formatDate(),
        "(HandleLoginSuccess) areaID: ",
        this.$globalVariable.USER_INFO.areaID
      );
      console.log(
        this.formatDate(),
        "(HandleLoginSuccess) isActive: ",
        this.$globalVariable.USER_INFO.isActive
      );
      console.log(
        this.formatDate(),
        "(HandleLoginSuccess) language: ",
        this.$globalVariable.USER_INFO.language
      );
      console.log(
        this.formatDate(),
        "(HandleLoginSuccess) jobName: ",
        this.$globalVariable.USER_INFO.jobName
      );
      console.log(
        this.formatDate(),
        "(HandleLoginSuccess) phone: ",
        this.$globalVariable.USER_INFO.phone
      );
      console.log(
        this.formatDate(),
        "(HandleLoginSuccess) admin: ",
        this.$globalVariable.USER_INFO.admin
      );

      const apiUrl = this.$globalVariable.URL_API + "/Files/get_drive_info/";
      console.log(this.formatDate(), "(HandleLoginSuccess) apiUrl: ", apiUrl);

      var path_data = "E:\\Drive_W\\Data";
      if (this.$globalVariable.RUNNING_DOCKER) {
        path_data = "/Data/Data";
      }

      const jsonData = {
        path: path_data,
        userID: this.$globalVariable.USER_INFO.userID,
        jobID: this.$globalVariable.USER_INFO.jobID,
        areaID: this.$globalVariable.USER_INFO.areaID,
        admin: this.$globalVariable.USER_INFO.admin,
      };

      const jsonString = JSON.stringify(jsonData);
      console.log(this.formatDate(), "(HandleLoginSuccess) jsonData: ", jsonData);
      console.log(this.formatDate(), "(HandleLoginSuccess) jsonString: ", jsonString);

      this.isLoginSuccess = false;
      await axios
        .post(apiUrl, jsonString, {
          headers: {
            "Content-Type": "application/json",
          },
        })
        .then((response) => {
          this.processResponseDriveInfo(response.data);
        })
        .catch((error) => {
          console.error(error);
        });
    },
    signalClearDataTable() {
      console.log("signalClearDataTable");
      this.listFiles = [];
      this.sizeAllFiles = 0;
      this.active_icon_loading = true;
    },
    handleReloadDataSearch(params) {
      this.active_icon_loading = false;
      const { dataResponse } = params;
      console.log("handleReloadDataSearch: ", dataResponse);
      this.listFilesSearch.push(dataResponse);
      this.isDataSearch = true;
      this.listFiles = [];
      this.oldListFiles = [];
      this.sizeAllFiles = 0;
      if (dataResponse != "") {
        console.log("handleReloadDataSearch => data OK");

        console.log("dataFiles: ", dataResponse.dataFiles.length);
        for (let i = 0; i < dataResponse.dataFiles.length; i++) {
          const file = dataResponse.dataFiles[i];
          console.log("\t file: ", file);
          const id = file["id"];
          const FullName = file["Name"];

          console.log("\t\t id: ", id);
          console.log("\t\t FullName: ", FullName);

          const Data = file["Data"];
          console.log("\t\t Data: ", Data);
          const detail_Name = Data["Name"];
          const detail_LastWriteTime = Data["LastWriteTime"];
          const detail_CreationTime = Data["CreationTime"];
          const detail_DirectoryName = Data["DirectoryName"];
          const detail_Extension = Data["Extension"];
          const detail_IsReadOnly = Data["IsReadOnly"] === true;
          const detail_LastAccessTime = Data["LastAccessTime"];
          const detail_Length = Data["Length"];
          const detail_FullName = Data["FullName"];
          const detail_status = Data["status"];
          const detail_revision = Data["revision"];
          const detail_language = Data["language"];
          const detail_sheet = Data["sheet"];
          const detail_description = Data["description"];
          const detail_document_number = Data["document_number"];
          // this.$globalVariable.keySearch = true;
          // console.log(
          //   "[handleReloadDataSearch] this.$globalVariable.keySearch: ",
          //   this.$globalVariable.keySearch
          // );
          console.log("\t\t\t detail_Name: ", detail_Name);
          console.log("\t\t\t detail_LastWriteTime: ", detail_LastWriteTime);
          console.log("\t\t\t detail_CreationTime: ", detail_CreationTime);
          console.log("\t\t\t detail_DirectoryName: ", detail_DirectoryName);
          console.log("\t\t\t detail_Extension: ", detail_Extension);
          console.log("\t\t\t detail_IsReadOnly: ", detail_IsReadOnly);
          console.log("\t\t\t detail_LastAccessTime: ", detail_LastAccessTime);
          console.log("\t\t\t detail_Length: ", detail_Length);
          console.log("\t\t\t detail_FullName: ", detail_FullName);

          var dataFile = {
            id: i,
            Name: detail_Name,
            FullName: FullName,
            LastWriteTime: detail_LastWriteTime,
            CreationTime: detail_CreationTime,
            DirectoryName: detail_DirectoryName,
            Extension: detail_Extension,
            IsReadOnly: detail_IsReadOnly,
            LastAccessTime: detail_LastAccessTime,
            Length: detail_Length,
            Status: detail_status,
            Language: detail_language,
            Revision: detail_revision,
            Sheet: detail_sheet,
            Description: detail_description,
            DocumentNumber: detail_document_number,
          };
          this.listFiles.push(dataFile);
          this.oldListFiles.push(dataFile);
          this.sizeAllFiles = dataResponse.sizeAllFiles;
        }
        console.log("handleReloadDataSearch: ", this.listFiles, " (files)");
        console.log("(handleReloadDataSearch) List File Search: ", this.listFilesSearch);
      } else {
        console.log("handleReloadDataSearch => data Error");
      }
    },
    slot_close_menu() {
      console.log(this.formatDate(), "(ComponentMain) slot_close_menu");
      this.menuVisible = false;
    },
    slot_show_menu() {
      console.log(this.formatDate(), "(ComponentMain) slot_show_menu");
      this.menuVisible = true;
    },
    slot_show_menu_grid_layout() {
      this.menuVisibleGridLayout = true;
    },
    handleMouseDown(event) {
      console.log(this.formatDate(), "(ComponentMain) handleMouseDown: ", event.target);
      console.log(
        this.formatDate(),
        "(ComponentMain) x = ",
        event.clientX,
        " and y = ",
        event.clientY
      );
      const targetClass = event.target.classList;
      console.log(this.formatDate(), "(ComponentMain) targetClass: ", targetClass);
      if (
        targetClass.contains("custom-menu") ||
        targetClass.contains("custom-menu-preview") ||
        targetClass.contains("custom-menu-download") ||
        targetClass.contains("custom-menu-highlight") ||
        targetClass.contains("custom-menu-highlight-color") ||
        targetClass.contains("custom-menu-save-list")
      ) {
        console.log(this.formatDate(), "(ComponentMain) this is class custom-menu");
      } else {
        console.log(this.formatDate(), "(ComponentMain) this is class others");
        this.menuVisible = false;
      }
    },
    async handleEmitTreeNode(params) {
      console.log("paramsparams", params);
      this.$globalVariable.FILTER_ROWS.is_active = false;
      this.isClickItemTreeNode = true;
      const { id, name, fullName, isBrowse } = params;
      this.listFilesSearch = [];
      console.log("(handleEmitTreeNode) List File Search: ", this.listFilesSearch);
      this.isLoadingTreeNodeItem[id] = true;

      this.oldListFiles = [];
      // this.listFiles = [];
      this.directorySelected = name;
      this.fullPathDirectoryBrowseBefore = fullName;
      if (isBrowse == false) {
        this.fullPathDirectoryBrowseAfter = "/";
      }

      let tabSelected = 0;
      if (this.$globalVariable.PAGE_CURRENT == "browse") {
        tabSelected = 1;
      } else if (this.$globalVariable.PAGE_CURRENT == "favorites") {
        tabSelected = 2;
      } else if (this.$globalVariable.PAGE_CURRENT == "home") {
        tabSelected = 3;
      }
      const jsonData = {
        id: id,
        name: name,
        path: fullName,
        user_id: this.$globalVariable.USER_INFO.userID,
        tabSelected: tabSelected,
      };

      const jsonString = JSON.stringify(jsonData);
      await axios
        .post(this.$globalVariable.URL_API + "/Files/expand_directory_v1", jsonString, {
          headers: {
            "Content-Type": "application/json",
          },
        })
        .then((response) => {
          if (!this.isDataSearch) {
            this.processResponseExplandDirectory(response.data, isBrowse);
          }
          this.fullPathDirectorySelected = fullName;
          this.fullPathDirectoryBrowseAfter = fullName;

          if (isBrowse == false) {
            this.fullPathDirectory = fullName;
          }
        })
        .catch((error) => {
          console.error(error);
        });
      this.isLoadingTreeNodeItem[id] = false;
    },
    handleEmit(payload) {
      console.log("Handle Add New File emit from children: ", payload);
    },
    toggleMenuItem(item) {
      item.visible = !item.visible;
    },
    ActionSearch(path) {
      console.log("Click Button Search");
      const value = this.$refs.inputValueSearch.value;
      if (value == "") {
        console.log("Warning: Please input value");
      } else {
        console.log("Key search: ", value);

        const jsonData = {
          name: value,
          path: path,
        };

        const jsonString = JSON.stringify(jsonData);
        console.log("jsonData: ", jsonData);
        console.log("jsonString: ", jsonString);
        console.log("path: ", path);
        axios
          .post(this.$globalVariable.URL_API + "/Files/search_file/", jsonString, {
            headers: {
              "Content-Type": "application/json",
            },
          })
          .then((response) => {
            console.log(response.data);
            this.processResponse(response.data);
          })
          .catch((error) => {
            console.error(error);
          });
      }
    },
    AddNewFile() {
      console.log("Click Add New File");
    },
    AddNewFolder() {
      console.log("Click Add New Folder");
      this.isFormAddNewFolderVisible = true;
      this.isOpenPopup = true;
    },
    GetDirectory(path) {
      console.log("Click Get Directory: ", path);
      const apiUrl = this.$globalVariable.URL_API + "/WeatherForecast/get_directory/";
      axios
        .get(apiUrl, {
          params: {
            path: path,
          },
        })
        .then((response) => {
          this.processResponse(response.data);
        })
        .catch((error) => {
          console.error(error);
        });
    },
    processResponse(jsonString) {
      try {
        console.log(jsonString);
        console.log("path: ", jsonString.path);
        console.log("dataDirectories: ", jsonString.dataDirectories.length);
        for (let i = 0; i < jsonString.dataDirectories.length; i++) {
          const directory = jsonString.dataDirectories[i];
          console.log("\t directory: ", directory);
          const id = directory["id"];
          const Name = directory["Name"];
          console.log("\t\t id: ", id);
          console.log("\t\t Name: ", Name);
        }
        console.log("dataFiles: ", jsonString.dataFiles.length);
        for (let i = 0; i < jsonString.dataFiles.length; i++) {
          const file = jsonString.dataFiles[i];
          console.log("\t file: ", file);
          const id = file["id"];
          const Name = file["Name"];
          const Data = file["Data"];
          console.log("\t\t id: ", id);
          console.log("\t\t Name: ", Name);
          console.log("\t\t Data: ", Data);
          const detail_Name = Data["Name"];
          const detail_LastWriteTime = Data["LastWriteTime"];
          const detail_CreationTime = Data["CreationTime"];
          const detail_DirectoryName = Data["DirectoryName"];
          const detail_Extension = Data["Extension"];
          const detail_IsReadOnly = Data["IsReadOnly"];
          const detail_LastAccessTime = Data["LastAccessTime"];
          const detail_Length = Data["Length"];
          console.log("\t\t\t detail_Name: ", detail_Name);
          console.log("\t\t\t detail_LastWriteTime: ", detail_LastWriteTime);
          console.log("\t\t\t detail_CreationTime: ", detail_CreationTime);
          console.log("\t\t\t detail_DirectoryName: ", detail_DirectoryName);
          console.log("\t\t\t detail_Extension: ", detail_Extension);
          console.log("\t\t\t detail_IsReadOnly: ", detail_IsReadOnly);
          console.log("\t\t\t detail_LastAccessTime: ", detail_LastAccessTime);
          console.log("\t\t\t detail_Length: ", detail_Length);
        }
      } catch (error) {
        console.log("error: ", error);
      }
    },
    processResponseDriveInfo(jsonString) {
      try {
        console.log(this.formatDate(), "processResponseDriveInfo: ", jsonString);
        console.log(this.formatDate(), "path: ", jsonString.path);
        console.log(
          this.formatDate(),
          "dataDirectories: ",
          jsonString.dataDirectories.length
        );

        this.tree = [];
        this.lastIdTree = 0;
        this.dataOriginal = "";

        for (let i = 0; i < jsonString.dataDirectories.length; i++) {
          const directory = jsonString.dataDirectories[i];
          console.log(this.formatDate(), "\t directory: ", directory);
          const Name = directory["Name"];
          const DriveType = directory["DriveType"];
          const IsReady = directory["IsReady"];
          const VolumeLabel = directory["VolumeLabel"];
          const DriveFormat = directory["DriveFormat"];
          const AvailableFreeSpace = directory["AvailableFreeSpace"];
          const TotalFreeSpace = directory["TotalFreeSpace"];
          const TotalSize = directory["TotalSize"];
          const fullName = directory["FullName"];
          const bookmark = directory["bookmark"];
          const isExpanded = directory["isExpanded"];
          const tabSelected = directory["tabSelected"];
          console.log(this.formatDate(), "\t\t Name: ", Name);
          console.log(this.formatDate(), "\t\t DriveType: ", DriveType);
          console.log(this.formatDate(), "\t\t IsReady: ", IsReady);
          console.log(this.formatDate(), "\t\t VolumeLabel: ", VolumeLabel);
          console.log(this.formatDate(), "\t\t DriveFormat: ", DriveFormat);
          console.log(this.formatDate(), "\t\t AvailableFreeSpace: ", AvailableFreeSpace);
          console.log(this.formatDate(), "\t\t TotalFreeSpace: ", TotalFreeSpace);
          console.log(this.formatDate(), "\t\t TotalSize: ", TotalSize);
          console.log(this.formatDate(), "\t\t fullName: ", fullName);

          var data = {
            id: this.lastIdTree++,
            name: Name,
            fullName: fullName,
            bookmark: bookmark,
            isExpanded: isExpanded,
            tabSelected: tabSelected,
            isTabFavorites: false,
            children: [],
          };

          console.log(
            this.formatDate(),
            "SubDirectories: ",
            directory.SubDirectories.length
          );
          for (let j = 0; j < directory.SubDirectories.length; j++) {
            const subDirectory = directory.SubDirectories[j];
            const subID = subDirectory["id"];
            const subName = subDirectory["Name"];
            const subFullName = subDirectory["FullName"];
            const isExpandedSub = subDirectory["isExpanded"];
            const subTabSelected = subDirectory["tabSelected"];
            console.log(this.formatDate(), "\t\t subID: ", subID);
            console.log(this.formatDate(), "\t\t subName: ", subName);
            console.log(this.formatDate(), "\t\t subFullName: ", subFullName);

            var subData = {
              id: this.lastIdTree++,
              name: subName,
              fullName: subFullName,
              isExpanded: isExpandedSub,
              tabSelected: subTabSelected,
              children: [],
            };
            data.children.push(subData);
          }

          this.tree.push(data);
        }
        console.log(this.formatDate(), "tree: ", this.tree);
        console.log(this.formatDate(), "lastIdTree: ", this.lastIdTree);

        console.log(
          this.formatDate(),
          "[column_configuration] dataColumnConfiguration: ",
          jsonString.dataColumnConfiguration
        );
        this.$globalVariable.COLUMN_CONFIGURATION.author =
          jsonString.dataColumnConfiguration["author"];
        this.$globalVariable.COLUMN_CONFIGURATION.last_check_in =
          jsonString.dataColumnConfiguration["last_check_in"];
        this.$globalVariable.COLUMN_CONFIGURATION.status =
          jsonString.dataColumnConfiguration["status"];
        this.$globalVariable.COLUMN_CONFIGURATION.version =
          jsonString.dataColumnConfiguration["version"];
        this.$globalVariable.COLUMN_CONFIGURATION.size =
          jsonString.dataColumnConfiguration["size"];
        this.$globalVariable.COLUMN_CONFIGURATION.autom_rev =
          jsonString.dataColumnConfiguration["autom_rev"];
        this.$globalVariable.COLUMN_CONFIGURATION.description =
          jsonString.dataColumnConfiguration["description"];
        this.$globalVariable.COLUMN_CONFIGURATION.language =
          jsonString.dataColumnConfiguration["language"];
        this.$globalVariable.COLUMN_CONFIGURATION.revision =
          jsonString.dataColumnConfiguration["revision"];
        this.$globalVariable.COLUMN_CONFIGURATION.sheet =
          jsonString.dataColumnConfiguration["sheet"];
        this.$globalVariable.COLUMN_CONFIGURATION.document_number =
          jsonString.dataColumnConfiguration["document_number"];

        console.log(
          this.formatDate(),
          "[column_configuration] (initialize) author: ",
          this.$globalVariable.COLUMN_CONFIGURATION.author
        );
        console.log(
          this.formatDate(),
          "[column_configuration] (initialize) last_check_in: ",
          this.$globalVariable.COLUMN_CONFIGURATION.last_check_in
        );
        console.log(
          this.formatDate(),
          "[column_configuration] (initialize) status: ",
          this.$globalVariable.COLUMN_CONFIGURATION.status
        );
        console.log(
          this.formatDate(),
          "[column_configuration] (initialize) version: ",
          this.$globalVariable.COLUMN_CONFIGURATION.version
        );
        console.log(
          this.formatDate(),
          "[column_configuration] (initialize) size: ",
          this.$globalVariable.COLUMN_CONFIGURATION.size
        );
        console.log(
          this.formatDate(),
          "[column_configuration] (initialize) autom_rev: ",
          this.$globalVariable.COLUMN_CONFIGURATION.autom_rev
        );
        console.log(
          this.formatDate(),
          "[column_configuration] (initialize) description: ",
          this.$globalVariable.COLUMN_CONFIGURATION.description
        );

        this.HandleChangeTabName(this.$globalVariable.TAB_CURRENT);
      } catch (error) {
        console.log("error: ", error);
      }
    },
    showTreeChildren(treeItem, childrenReponse, idResponse) {
      for (let i = 0; i < treeItem.children.length; i++) {
        // console.log("\t children index: ", i);
        const childrenItem = treeItem.children[i];

        const id = childrenItem.id;
        // const Name = childrenItem.name;
        // const FullName = childrenItem.fullName;
        const children = childrenItem.children.length;
        // console.log("[showTreeChildren] childrenItem: ", childrenItem);
        // console.log("[showTreeChildren] children length: ", children);

        // console.log("\t\t id: ", id);
        // console.log("\t\t Name: ", Name);
        // console.log("\t\t FullName: ", FullName);
        // console.log("\t\t children: ", children);
        if (idResponse == id) {
          childrenItem.children = childrenReponse;
          // console.log("\t (checking tree) =========>> Found 2");
        } else if (children > 0) {
          this.showTreeChildren(childrenItem, childrenReponse, idResponse);
        }
      }
    },
    processResponseExplandDirectory(jsonString, isBrowse) {
      try {
        console.log(
          this.formatDate(),
          "(processResponseExplandDirectory) JsonString: ",
          jsonString
        );
        var idResponse = jsonString.id;
        console.log(this.formatDate(), "(Tree_Node_Click_Main) isBrowse: ", isBrowse);

        this.sizeAllFiles = jsonString.sizeAllFiles;

        var childrenReponse = [];
        var childrenReponseBrowse = [];
        this.dataOriginal = jsonString;

        // Check parent
        let parentDirectory = "/";
        parentDirectory = jsonString.FullName.split("\\");
        if (parentDirectory.length > 0) {
          const lastItem = "\\" + parentDirectory[parentDirectory.length - 1];
          parentDirectory = jsonString.FullName.replace(lastItem, "");
        }

        // if (this.$globalVariable.RUNNING_DOCKER) {
        //     parentDirectory = jsonString.FullName.split("/");
        //     if (parentDirectory.length > 0) {
        //         const lastItem = "/" + parentDirectory[parentDirectory.length - 1];
        //         parentDirectory = jsonString.FullName.replace(lastItem, "");
        //     }
        // } else {
        //     parentDirectory = jsonString.FullName.split("\\");
        //     if (parentDirectory.length > 0) {
        //         const lastItem = "\\" + parentDirectory[parentDirectory.length - 1];
        //         parentDirectory = jsonString.FullName.replace(lastItem, "");
        //     }
        // }

        // End check parent

        // console.log("dataOriginal: ", this.dataOriginal);

        for (let i = 0; i < jsonString.dataDirectories.length; i++) {
          const directory = jsonString.dataDirectories[i];
          const Name = directory["Name"];
          const FullName = directory["FullName"];
          const bookmark = directory["bookmark"];
          const isExpanded = directory["isExpanded"];
          console.log("[processResponseExplandDirectory] directory: ", directory);

          var data = {
            id: this.lastIdTree++,
            name: Name,
            fullName: FullName,
            bookmark: bookmark,
            isExpanded: isExpanded,
            isTabFavorites: false,
            children: [],
          };

          var dataBrowse = {
            id: this.lastIdTree++,
            name: Name,
            fullName: FullName,
            bookmark: bookmark,
            isExpanded: isExpanded,
            isTabFavorites: false,
            children: [],
          };

          childrenReponse.push(data);
          childrenReponseBrowse.push(dataBrowse);
        }

        // Update data Browse
        this.treeBrowse = [];
        var dataPrevious = {
          id: this.lastIdTree++,
          name: "...",
          fullName: parentDirectory,
          bookmark: false,
          isExpanded: false,
          isTabFavorites: false,
          children: [],
        };
        this.treeBrowse = childrenReponseBrowse;
        if (
          this.fullPathDirectoryBrowseAfter == "/" ||
          this.fullPathDirectoryBrowseBefore == this.fullPathDirectory
        ) {
          // Root
        } else {
          this.treeBrowse.unshift(dataPrevious);
        }
        this.listFiles = [];
        for (let i = 0; i < jsonString.dataFiles.length; i++) {
          const file = jsonString.dataFiles[i];
          console.log("(processResponseExplandDirectory) file: ", file);
          const FullName = file["Name"];
          const Data = file["Data"];
          const detail_Name = Data["Name"];
          const detail_LastWriteTime = Data["LastWriteTime"];
          const detail_CreationTime = Data["CreationTime"];
          const detail_DirectoryName = Data["DirectoryName"];
          const detail_Extension = Data["Extension"];
          const detail_IsReadOnly = Data["IsReadOnly"] === true;
          const detail_LastAccessTime = Data["LastAccessTime"];
          const detail_Length = Data["Length"];
          const detail_revision = Data["revision"];
          const detail_description = Data["description"];
          const detail_document_number = Data["document_number"];
          const detail_language = Data["language"];
          const detail_sheet = Data["sheet"];
          const detail_status = Data["status"];

          var dataFile = {
            id: i,
            Name: detail_Name,
            FullName: FullName,
            LastWriteTime: detail_LastWriteTime,
            CreationTime: detail_CreationTime,
            DirectoryName: detail_DirectoryName,
            Extension: detail_Extension,
            IsReadOnly: detail_IsReadOnly,
            LastAccessTime: detail_LastAccessTime,
            Length: detail_Length,
            Revision: detail_revision,
            Description: detail_description,
            DocumentNumber: detail_document_number,
            Language: detail_language,
            Sheet: detail_sheet,
            Status: detail_status,
          };
          console.log("(processResponseExplandDirectory) dataFile: ", dataFile);

          this.listFiles.push(dataFile);
        }

        for (let i = 0; i < this.tree.length; i++) {
          const treeItem = this.tree[i];
          const id = treeItem.id;

          if (idResponse == id) {
            treeItem.children = childrenReponse;
          } else {
            this.showTreeChildren(treeItem, childrenReponse, idResponse);
          }
        }
        this.listRightAndRoles = [];
        for (let i = 0; i < jsonString.dataRightAndRoles.length; i++) {
          const RightAndRolesItem = jsonString.dataRightAndRoles[i];
          const detail_Username = RightAndRolesItem["Username"];
          const detail_FullControl = RightAndRolesItem["FullControl"];
          const detail_Modify = RightAndRolesItem["Modify"];
          const detail_ReadAndExecute = RightAndRolesItem["ReadAndExecute"];
          const detail_Write = RightAndRolesItem["Write"];
          const detail_Synchronize = RightAndRolesItem["Synchronize"];
          var dataRightAndRolesItem = {
            id: i + 1,
            Username: detail_Username,
            FullControl: detail_FullControl,
            Modify: detail_Modify,
            ReadAndExecute: detail_ReadAndExecute,
            Write: detail_Write,
            Synchronize: detail_Synchronize,
          };
          this.isCheckRightandRoles_fullControl[i] = dataRightAndRolesItem.FullControl;
          this.isCheckRightandRoles_modify[i] = dataRightAndRolesItem.Modify;
          this.isCheckRightandRoles_readAndExecute[i] =
            dataRightAndRolesItem.ReadAndExecute;
          this.isCheckRightandRoles_write[i] = dataRightAndRolesItem.Write;
          this.isCheckRightandRoles_synchronize[i] = dataRightAndRolesItem.Synchronize;
          this.listRightAndRoles.push(dataRightAndRolesItem);
        }

        this.$globalVariable.GENERAL_DIRECTORY.name = jsonString.dataDirectory["name"];
        this.$globalVariable.GENERAL_DIRECTORY.fullname =
          jsonString.dataDirectory["fullname"];
        this.$globalVariable.GENERAL_DIRECTORY.type = jsonString.dataDirectory["type"];
        this.$globalVariable.GENERAL_DIRECTORY.location =
          jsonString.dataDirectory["location"];
        this.$globalVariable.GENERAL_DIRECTORY.files = jsonString.dataDirectory["files"];
        this.$globalVariable.GENERAL_DIRECTORY.directories =
          jsonString.dataDirectory["directories"];
        this.$globalVariable.GENERAL_DIRECTORY.size = jsonString.dataDirectory["size"];
        this.$globalVariable.GENERAL_DIRECTORY.length =
          jsonString.dataDirectory["length"];
        this.$globalVariable.GENERAL_DIRECTORY.creationTime =
          jsonString.dataDirectory["creationTime"];
        this.$globalVariable.GENERAL_DIRECTORY.lastWriteTime =
          jsonString.dataDirectory["lastWriteTime"];
        this.$globalVariable.GENERAL_DIRECTORY.lastAccessTime =
          jsonString.dataDirectory["lastAccessTime"];
      } catch (error) {
        console.log(this.formatDate(), "error: ", error);
      }

      this.HandleChangeTabName(this.$globalVariable.TAB_CURRENT);
    },
    processResponseDropFiles(jsonString) {
      try {
        console.log("[handleDropFile] jsonString: ", jsonString);
        console.log("[handleDropFile] name: ", jsonString.name);
        console.log("[handleDropFile] path: ", jsonString.path);
        console.log("[handleDropFile] FullName: ", jsonString.FullName);
        console.log("[handleDropFile] CreationTime: ", jsonString.CreationTime);
        console.log("[handleDropFile] LastAccessTime: ", jsonString.LastAccessTime);
        console.log("[handleDropFile] LastWriteTime: ", jsonString.LastWriteTime);
        console.log(
          "[handleDropFile] dataDirectories: ",
          jsonString.dataDirectories.length
        );
        console.log("[handleDropFile] sizeAllFiles: ", jsonString.sizeAllFiles);
        this.sizeAllFiles = jsonString.sizeAllFiles;

        this.dataOriginal = jsonString;
        this.listFiles = [];
        console.log("[handleDropFile] dataFiles: ", jsonString.dataFiles.length);
        for (let i = 0; i < jsonString.dataFiles.length; i++) {
          const file = jsonString.dataFiles[i];
          console.log("[handleDropFile] file: ", file);
          const id = file["id"];
          const FullName = file["Name"];

          console.log("[handleDropFile] id: ", id);
          console.log("[handleDropFile] FullName: ", FullName);

          const Data = file["Data"];
          console.log("[handleDropFile] Data: ", Data);
          const detail_Name = Data["Name"];
          const detail_LastWriteTime = Data["LastWriteTime"];
          const detail_CreationTime = Data["CreationTime"];
          const detail_DirectoryName = Data["DirectoryName"];
          const detail_Extension = Data["Extension"];
          const detail_IsReadOnly = Data["IsReadOnly"] === true;
          const detail_LastAccessTime = Data["LastAccessTime"];
          const detail_Length = Data["Length"];
          console.log("[handleDropFile] detail_Name: ", detail_Name);
          console.log("[handleDropFile] detail_LastWriteTime: ", detail_LastWriteTime);
          console.log("[handleDropFile] detail_CreationTime: ", detail_CreationTime);
          console.log("[handleDropFile] detail_DirectoryName: ", detail_DirectoryName);
          console.log("[handleDropFile] detail_Extension: ", detail_Extension);
          console.log("[handleDropFile] detail_IsReadOnly: ", detail_IsReadOnly);
          console.log("[handleDropFile] detail_LastAccessTime: ", detail_LastAccessTime);
          console.log("[handleDropFile] detail_Length: ", detail_Length);

          var dataFile = {
            id: i,
            Name: detail_Name,
            FullName: FullName,
            LastWriteTime: detail_LastWriteTime,
            CreationTime: detail_CreationTime,
            DirectoryName: detail_DirectoryName,
            Extension: detail_Extension,
            IsReadOnly: detail_IsReadOnly,
            LastAccessTime: detail_LastAccessTime,
            Length: detail_Length,
          };
          this.listFiles.push(dataFile);
        }
        console.log("[handleDropFile] listFiles: ", this.listFiles);

        this.listRightAndRoles = [];
        console.log(
          "[handleDropFile] dataRightAndRoles Length: ",
          jsonString.dataRightAndRoles.length
        );
        for (let i = 0; i < jsonString.dataRightAndRoles.length; i++) {
          const RightAndRolesItem = jsonString.dataRightAndRoles[i];
          console.log(
            "[handleDropFile] [dataRightAndRoles] RightAndRolesItem: ",
            RightAndRolesItem
          );
          const detail_Username = RightAndRolesItem["Username"];
          const detail_FullControl = RightAndRolesItem["FullControl"];
          const detail_Modify = RightAndRolesItem["Modify"];
          const detail_ReadAndExecute = RightAndRolesItem["ReadAndExecute"];
          const detail_Write = RightAndRolesItem["Write"];
          const detail_Synchronize = RightAndRolesItem["Synchronize"];
          console.log(
            "[handleDropFile] [dataRightAndRoles]  detail_Username: ",
            detail_Username
          );
          console.log(
            "[handleDropFile] [dataRightAndRoles]  detail_FullControl: ",
            detail_FullControl
          );
          console.log(
            "[handleDropFile] [dataRightAndRoles]  detail_Modify: ",
            detail_Modify
          );
          console.log(
            "[handleDropFile] [dataRightAndRoles]  detail_ReadAndExecute: ",
            detail_ReadAndExecute
          );
          console.log(
            "[handleDropFile] [dataRightAndRoles]  detail_Write: ",
            detail_Write
          );
          console.log(
            "[handleDropFile] [dataRightAndRoles]  detail_Synchronize: ",
            detail_Synchronize
          );
          var dataRightAndRolesItem = {
            id: i + 1,
            Username: detail_Username,
            FullControl: detail_FullControl,
            Modify: detail_Modify,
            ReadAndExecute: detail_ReadAndExecute,
            Write: detail_Write,
            Synchronize: detail_Synchronize,
          };
          this.isCheckRightandRoles_fullControl[i] = dataRightAndRolesItem.FullControl;
          this.isCheckRightandRoles_modify[i] = dataRightAndRolesItem.Modify;
          this.isCheckRightandRoles_readAndExecute[i] =
            dataRightAndRolesItem.ReadAndExecute;
          this.isCheckRightandRoles_write[i] = dataRightAndRolesItem.Write;
          this.isCheckRightandRoles_synchronize[i] = dataRightAndRolesItem.Synchronize;
          this.listRightAndRoles.push(dataRightAndRolesItem);
        }

        console.log("[handleDropFile] dataDirectory: ", jsonString.dataDirectory);
        this.$globalVariable.GENERAL_DIRECTORY.name = jsonString.dataDirectory["name"];
        this.$globalVariable.GENERAL_DIRECTORY.fullname =
          jsonString.dataDirectory["fullname"];
        this.$globalVariable.GENERAL_DIRECTORY.type = jsonString.dataDirectory["type"];
        this.$globalVariable.GENERAL_DIRECTORY.location =
          jsonString.dataDirectory["location"];
        this.$globalVariable.GENERAL_DIRECTORY.files = jsonString.dataDirectory["files"];
        this.$globalVariable.GENERAL_DIRECTORY.directories =
          jsonString.dataDirectory["directories"];
        this.$globalVariable.GENERAL_DIRECTORY.size = jsonString.dataDirectory["size"];
        this.$globalVariable.GENERAL_DIRECTORY.length =
          jsonString.dataDirectory["length"];
        this.$globalVariable.GENERAL_DIRECTORY.creationTime =
          jsonString.dataDirectory["creationTime"];
        this.$globalVariable.GENERAL_DIRECTORY.lastWriteTime =
          jsonString.dataDirectory["lastWriteTime"];
        this.$globalVariable.GENERAL_DIRECTORY.lastAccessTime =
          jsonString.dataDirectory["lastAccessTime"];

        console.log(
          "[handleDropFile] [dataDirectory] name: ",
          this.$globalVariable.GENERAL_DIRECTORY.name
        );
        console.log(
          "[handleDropFile] [dataDirectory] fullname: ",
          this.$globalVariable.GENERAL_DIRECTORY.fullname
        );
        console.log(
          "[handleDropFile] [dataDirectory] type: ",
          this.$globalVariable.GENERAL_DIRECTORY.type
        );
        console.log(
          "[handleDropFile] [dataDirectory] location: ",
          this.$globalVariable.GENERAL_DIRECTORY.location
        );
        console.log(
          "[handleDropFile] [dataDirectory] files: ",
          this.$globalVariable.GENERAL_DIRECTORY.files
        );
        console.log(
          "[handleDropFile] [dataDirectory] directories: ",
          this.$globalVariable.GENERAL_DIRECTORY.directories
        );
        console.log(
          "[handleDropFile] [dataDirectory] size: ",
          this.$globalVariable.GENERAL_DIRECTORY.size
        );
        console.log(
          "[handleDropFile] [dataDirectory] length: ",
          this.$globalVariable.GENERAL_DIRECTORY.length
        );
        console.log(
          "[handleDropFile] [dataDirectory] creationTime: ",
          this.$globalVariable.GENERAL_DIRECTORY.creationTime
        );
        console.log(
          "[handleDropFile] [dataDirectory] lastWriteTime: ",
          this.$globalVariable.GENERAL_DIRECTORY.lastWriteTime
        );
        console.log(
          "[handleDropFile] [dataDirectory] lastAccessTime: ",
          this.$globalVariable.GENERAL_DIRECTORY.lastAccessTime
        );
      } catch (error) {
        console.log("[handleDropFile] error: ", error);
      }
      this.HandleChangeTabName(this.$globalVariable.TAB_CURRENT);
    },
    //Clear highlight
    handleHighlightColor() {
      this.clearAllHighlights();
    },
    clearAllHighlights() {
      for (let i = 0; i < this.tree.length; i++) {
        this.clearHighlightNode(this.tree[i]);
        this.clearHighlightChildren(this.tree[i]);
      }
    },
    clearHighlightNode(node) {
      const element = document.getElementById(node.id);

      // console.log("element ID children: ", element);
      if (element) {
        element.style.background = "";
      }
    },
    clearHighlightChildren(node) {
      for (let i = 0; i < node.children.length; i++) {
        this.clearHighlightNode(node.children[i]);
        if (node.children[i].children.length > 0) {
          this.clearHighlightChildren(node.children[i]);
        }
      }
    },

    async getChildrenNode(tree, listFolderName) {
      console.log("listForder,", tree, listFolderName);
      let node = tree.filter(
        (item) => item.name.toString().trim() === listFolderName[0].toString().trim()
      )[0];
      // let indexNode = tree.findIndex(
      //   (element) =>
      //     element.name.toString().trim() === listFolderName[0].toString().trim()
      // );
      console.log("[handleHighlightFrom] Node: ", node);
      if (node) {
        // this.$refs.treeNode[indexNode].handleExpanded();
        this.childHightLight = node.name;
        await this.handleEmitTreeNode({
          fullName: node.fullName,
          id: node.id,
          name: node.name,
          isBrowse: false,
        });
        let listTreeChildren = node.children;
        console.log("[handleHighlightFrom] listTreeChildren: ", listTreeChildren);
        this.childrenTree = listTreeChildren;
      }
    },

    //Add highlight
    async handleHighlightFrom(params) {
      const { fileName, filePath, fileId } = params;

      if (this.isDataSearch) {
        let listFolderName = filePath.split("E:\\Drive_W\\Data")[1].split("\\");
        listFolderName.splice(0, 1);
        console.log("[handleHighlightFrom] File Path: ", listFolderName);
        let listTree = this.tree.map((item) => item.name);

        console.log("[handleHighlightFrom] List Tree: ", listTree, listFolderName[0]);
        if (listTree.includes(listFolderName[0])) {
          this.getChildrenNode(this.tree, listFolderName);
          listFolderName.splice(0, 1);
          console.log("[handleHighlightFrom] Children Tree: ", this.childrenTree);

          if (
            this.childrenTree &&
            listFolderName &&
            this.childrenTree.length > 0 &&
            listFolderName.length > 0
          ) {
            let list = listFolderName;
            list.map((item) => {
              if (this.childrenTree.length > 0 && item) {
                this.getChildrenNode(this.childrenTree, listFolderName);
                listFolderName.splice(0, 1);
              }
            });
          }
          console.log("[handleHighlightFrom] List Tree Children: ", this.childrenTree);
        }
      }

      this.highlightedNodes.push(fileId);
      this.handleHighlightFile(fileName, filePath, fileId);
    },

    highlightNode(nodeId, highlight, fileId, fileName, filePath) {
      const jsonHighlight = {
        fileId: fileId,
        fileName: fileName,
        filePath: filePath,
      };
      console.log("(highlightNode) Json Highlight: ", jsonHighlight);
      const elementS = document.getElementById(fileId);
      if (elementS) {
        if (highlight) {
          elementS.style.background = this.$globalVariable.COLOR;
        }
      }
      const element = document.getElementById(nodeId);
      console.log("element A: ", element);
      if (element) {
        console.log("(highlightNode) highlight: ", highlight);
        if (highlight) {
          element.style.background = this.$globalVariable.COLOR;
        } else {
          element.style.background = "";
        }
      }
    },
    handleHighlightFile(fileName, filePath, fileId) {
      let absolutePath = filePath;
      console.log("Folder in the: ", absolutePath);
      if (this.$globalVariable.RUNNING_DOCKER) {
        absolutePath = absolutePath.replace("E:\\Drive_W\\Data\\", "");
      } else if (absolutePath.includes("W:")) {
        absolutePath = absolutePath.replace("W:\\", "");
      } else if (absolutePath.includes("E:\\")) {
        console.log("E:\\: ổ E");
        absolutePath = absolutePath.replace("E:\\Drive_W\\Data\\", "");
      }

      const treeHighlight = [];
      for (let i = 0; i < this.tree.length; i++) {
        console.log("Full path highlight: ", this.tree[i]);
        let addStringFullName = this.$globalVariable.RUNNING_DOCKER
          ? this.tree[i].fullName + "\\"
          : this.tree[i].fullName + "\\";
        if (this.$globalVariable.RUNNING_DOCKER) {
          addStringFullName = addStringFullName.replace("E:\\Drive_W\\Data\\", "");
        } else if (addStringFullName.includes("E:\\Drive_W\\Data\\")) {
          addStringFullName = addStringFullName.replace("E:\\Drive_W\\Data\\", "");
        }
        const shouldHighlightNode = absolutePath.includes(addStringFullName);
        if (shouldHighlightNode) {
          treeHighlight.push(this.tree[i]);
        }
      }
      setTimeout(() => {
        this.highlightNode(treeHighlight[0].id, true, fileId, fileName, absolutePath);
        this.highlightChildren(treeHighlight[0], absolutePath);
      }, 700);
      // Fix highlight Search
      // this.oldListFiles = this.listFilesSearch;
      console.log("(handleHighlightFile) Highlight oldListFiles: ", this.oldListFiles);
    },

    handleIsDataSearch() {
      this.isDataSearch = false;
    },

    highlightChildren(node, path) {
      for (let i = 0; i < node.children.length; i++) {
        let addStringFullNameChildren = this.$globalVariable.RUNNING_DOCKER
          ? node.children[i].fullName + "\\"
          : node.children[i].fullName + "\\";
        if (this.$globalVariable.RUNNING_DOCKER) {
          addStringFullNameChildren = addStringFullNameChildren.replace(
            "E:\\Drive_W\\Data\\",
            ""
          );
        } else if (addStringFullNameChildren.includes("E:\\Drive_W\\Data\\")) {
          addStringFullNameChildren = addStringFullNameChildren.replace(
            "E:\\Drive_W\\Data\\",
            ""
          );
        }
        const shouldHighlightChild = path.includes(addStringFullNameChildren);
        this.highlightNode(node.children[i].id, shouldHighlightChild);
        if (node.children[i].children.length > 0) {
          this.highlightChildren(node.children[i], path);
        }
      }
    },

    async HandleSaveListContent(params, data) {
      try {
        const jsonData = {
          userID: this.$globalVariable.USER_INFO.userID,
          name: data.name,
          path: data.path,
        };
        const jsonString = JSON.stringify(jsonData);
        const resultArray = this.listFiles;
        const workbook = new ExcelJS.Workbook();
        const worksheet = workbook.addWorksheet("Sheet 1");
        const transformedArray = resultArray.map((object) => ({
          ...object,
          FullName: object.FullName.replace("E:\\Drive_W\\Data\\", "W:\\"),
        }));

        const worksheetColumns = [
          { header: "Title", key: "Name", width: 20 },
          { header: "Author", key: "", width: 10 },
          { header: "Path", key: "FullName", width: 40 },
          { header: "Date accessed", key: "LastAccessTime", width: 15 },
          { header: "Status", key: "Status", width: 10 },
          { header: "Revision", key: "Revision", width: 10 },
          { header: "Size", key: "Length", width: 15 },
          { header: "Autom. Rev.", key: "", width: 10 },
          { header: "Description", key: "Description", width: 40 },
          { header: "Language", key: "Language", width: 15 },
          { header: "Sheet", key: "Sheet", width: 15 },
          { header: "Document Number", key: "DocumentNumber", width: 30 },
        ];

        worksheetColumns.forEach((column, columnIndex) => {
          const cell = worksheet.getCell(1, columnIndex + 1);
          cell.value = column.header;
          cell.font = { bold: true };
          worksheet.getColumn(columnIndex + 1).width = column.width;
        });
        worksheet.columns = worksheetColumns;
        transformedArray.forEach((object) => {
          worksheet.addRow(object);
        });
        const blob = await workbook.xlsx.writeBuffer();
        const url = window.URL.createObjectURL(new Blob([blob]));
        const link = document.createElement("a");
        link.href = url;
        link.download = `Draw-Save-List_${this.formatDate()}.xlsx`;
        link.click();

        const response = await axios.post(
          this.$globalVariable.URL_API + "/WeatherForecast/save_list/",
          jsonString,
          {
            headers: {
              "Content-Type": "application/json",
            },
          }
        );

        console.log("[HandleSaveListContent] Response: ", response);
      } catch (error) {
        console.error("[HandleSaveListContent] Error: ", error);
      }
    },
    OpenPDF(fileName) {
      console.log("Click Open File PDF");
      axios
        .post(
          this.$globalVariable.URL_API + "/WeatherForecast/open_file_pdf/",
          {
            fileName,
          },
          {
            responseType: "blob",
          }
        )
        .then((response) => {
          console.log(response.data);
          const file = new Blob([response.data], {
            type: "application/pdf",
          });
          const fileURL = URL.createObjectURL(file);
          console.log("(OpenPDF) File URL: ", fileURL);
          const newTab = window.open(fileURL, "_blank");
          newTab.location.href = "ABCD";
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
    DownloadPDF(fileName) {
      console.log("Click Download File PDF");
      axios
        .post(
          this.$globalVariable.URL_API + "/WeatherForecast/download_file_pdf/",
          {
            fileName,
          },
          {
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
    DownloadPDFMedthodGet(fileName) {
      console.log("Click Download File PDF");
      axios
        .get(this.$globalVariable.URL_API + `/WeatherForecast/${fileName}`, {
          responseType: "blob",
        })
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
    DownloadPWG(fileName) {
      console.log("Click Download File DWG");
      axios
        .post(
          this.$globalVariable.URL_API + "/WeatherForecast/download_file_dwg/",
          {
            fileName,
          },
          {
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
    OpenPDFMethodGet(fileName) {
      console.log("Click Open File");
      let str = fileName;
      let character_pdf = "pdf";
      let character_dwg = "dwg";
      if (str.includes(character_pdf)) {
        console.log("This file PDF");
      } else if (str.includes(character_dwg)) {
        console.log("This file PWG");
      } else {
        console.log("Unknown type of the file");
      }

      axios
        .get(this.$globalVariable.URL_API + `/WeatherForecast/${fileName}`, {
          responseType: "blob",
        })
        .then((response) => {
          console.log(response.data);
          const file = new Blob([response.data], {
            type: "application/pdf",
          });
          const fileURL = URL.createObjectURL(file);
          if (str.includes(character_pdf)) {
            const newTab = window.open(fileURL, "_blank");
            newTab.location.href = "ABCD";
            newTab.onload = function () {
              newTab.document.write(
                `<html><head><title>${fileName}</title></head></html>`
              );
              newTab.document.body.innerHTML = `<embed src="${fileURL}" type="application/pdf" width="100%"" height="100%" />`;
              newTab.document.close();
            };
          }
        })
        .catch((error) => {
          console.error(error);
        });
    },
    OpenPWG(fileName) {
      console.log("Click Open File PWG");
      axios
        .post(
          this.$globalVariable.URL_API + "/WeatherForecast/open_file_dwg/",
          {
            fileName,
          },
          {
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
    fetchData() {
      axios
        .get(this.$globalVariable.URL_API + "/WeatherForecast")
        .then((response) => {
          console.log(response.data);
        })
        .catch((error) => {
          console.error(error);
        });
    },
    postData() {
      axios
        .post(this.$globalVariable.URL_API + "/WeatherForecast", {
          name: "Product 1",
        })
        .then((response) => {
          console.log(response.data);
        })
        .catch((error) => {
          console.error(error);
        });
    },
    handleAddNewFolder(name) {
      console.log(name);
    },
    handleAddNewFile(name) {
      console.log(name);
    },
    handleSearch(value) {
      console.log(value);
    },
    handlePreview(fileName) {
      console.log(fileName);
    },
    handleDownload(fileName) {
      console.log(fileName);
    },
  },
  computed: {
    roundNumber(value) {
      return value.toFixed(2);
    },
    divTreeNodeDirectoryStyle() {
      return {
        height: this.divHeightTreeNodeDirectory,
        // "border-bottom-left-radius": this.divBorderRadiusBottomLeftTreeNodeDirectory,
        // "border-bottom-right-radius": this.divBorderRadiusBottomRightTreeNodeDirectory,
      };
    },
  },
  watch: {
    "$globalVariable.COLOR": function (newColor) {
      console.log("($globalVariable.COLOR) watch: ", newColor);
    },
    fullPathDirectorySelected(newValue, oldValue) {
      console.log(
        this.formatDate(),
        "(fullPathDirectorySelected) change from [",
        oldValue,
        "] to [",
        newValue,
        "]"
      );
      this.$globalVariable.DIR_SELECTED = newValue;
    },
    // listFiles(newValue, oldValue) {
    //     console.log("[file_list] listFile change from ", oldValue, "to", newValue);
    // },
    // isMouseTreeNodeDirectory(newValue, oldValue) {
    //     console.log("isMouseTreeNodeDirectory change from ", oldValue, "to", newValue);
    // }
    isDraggingDivBrowse(newValue, oldValue) {
      console.log(
        this.formatDate(),
        "(DragDiv) [watch] change from ",
        oldValue,
        "to",
        newValue
      );
    },
  },
  beforeCreate() {
    // console.log('[Lift circle - ComponentMain] beforeCreate');
  },
  created() {
    // console.log('[Lift circle - ComponentMain] created');
    document.title = "Manager draw ";
    // Khôi phục trạng thái từ sessionStorage hoặc localStorage
    const savedState = window.sessionStorage.getItem("ManagerDrawState");
    // console.log("(created_init) savedState: ", savedState);
    if (savedState) {
      const appState = JSON.parse(savedState);
      // console.log("(created_init) appState: ", appState);
      const isLoggedIn = appState["isLoggedIn"];
      // console.log("(created_init) isLoggedIn: ", isLoggedIn);
      if (isLoggedIn) {
        console.log(this.formatDate(), "(created_init) Operator press F5");
        this.isLoginSuccess = false;
        this.$globalVariable.USER_INFO.id = appState["id"];
        this.$globalVariable.USER_INFO.fullName = appState["fullName"];
        this.$globalVariable.USER_INFO.userID = appState["userID"];
        this.$globalVariable.USER_INFO.email = appState["email"];
        this.$globalVariable.USER_INFO.password = appState["password"];
        this.$globalVariable.USER_INFO.jobID = appState["jobID"];
        this.$globalVariable.USER_INFO.kipID = appState["kipID"];
        this.$globalVariable.USER_INFO.workID = appState["workID"];
        this.$globalVariable.USER_INFO.areaID = appState["areaID"];
        this.$globalVariable.USER_INFO.isActive = appState["isActive"];
        this.$globalVariable.USER_INFO.language = appState["language"];
        this.$globalVariable.USER_INFO.jobName = appState["jobName"];
        this.$globalVariable.USER_INFO.phone = appState["phone"];
        this.$globalVariable.USER_INFO.admin = appState["admin"];
        this.$globalVariable.TEXT_LAYOUT = appState["text_layout"];

        if (this.$globalVariable.USER_INFO.language == 1) {
          this.$i18n.locale = "en";
        } else {
          this.$i18n.locale = "vi";
        }
        this.$globalVariable.TEXT_LAYOUT = this.$t("ListLayout");

        this.HandleLoginSuccess(this.$globalVariable.USER_INFO.userID);
      } else {
        console.log(this.formatDate(), "(created_init) Operator logout");
      }
    }
  },
  beforeMount() {
    // console.log('[Lift circle - ComponentMain] beforeMount');
  },
  mounted() {
    // console.log('[Lift circle - ComponentMain] mounted');
  },
  beforeUpdate() {
    // console.log('[Lift circle - ComponentMain] beforeUpdate');
  },
  updated() {
    // console.log('[Lift circle - ComponentMain] updated');
  },
  beforeUnmount() {
    // console.log('[Lift circle - ComponentMain] beforeUnmount');
  },
  Unmounted() {
    // console.log('[Lift circle - ComponentMain] Unmounted');
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->

<style scoped>
@import "@mdi/font/css/materialdesignicons.min.css";

.app {
  width: 100%;
  height: 100vh;
  border: 1px solid none;
  display: flex;
  flex-direction: column;
  min-width: 800px;
  border: none;
}

.header-class {
  font-family: Arial, Helvetica, sans-serif;
  background-color: #fff;
  color: #fff;
  text-align: left;
  border: 1px solid none;
  font-size: 20px;
  padding: 15px 30px;
  max-height: 60px;
  align-items: center;
}

.icon_header {
  display: inline-block;
  width: 330px;
  height: 51px;
  background-image: url(../assets/logo.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.custom-link {
  cursor: pointer;
}

.custom-link:hover {
  cursor: pointer;
}

.custom-link:active {
  cursor: grab;
}

.search {
  border-radius: 5px;
  width: 300px;
  height: 30;
  border: 1px solid transparent;
}

.btnSearch {
  margin-left: 10px;
  border-radius: 5px;
}

.tree-node-main {
  width: 100%;
  position: relative;
  border: none;
  height: calc(100% - 102px);
}

.tree-node-content {
  width: 100%;
  height: 100%;
  display: flex;
  position: absolute;
  border: none;
}

.parent-directory {
  /* font-family: Arial, Helvetica, sans-serif; */
  font-family: "Roboto", sans-serif;
  float: left;
  width: 20%;
  height: 100%;
  border: 1px solid none;
  text-align: left;
  min-width: 155px;
  max-width: 670px;
  /* overflow: auto; */
  /* background: linear-gradient(to bottom, #90CAF9, #01579B); */
  /* background: linear-gradient(to bottom, #ECEFF1, #263238); */
  background-color: #fff;
  /* user-select: none; */
}
.layout-right-flex {
  cursor: e-resize;
  user-select: none;
}

.parent-directory.dragging {
  background: linear-gradient(to bottom, grey, grey);
  cursor: not-allowed;
}

.tree-node-general {
  border: 1px solid transparent;
  height: calc(100% - 160px);
}

.tree-node-directory {
  display: flex;
  flex-direction: column;
  font-family: Arial, Helvetica, sans-serif;
  height: calc(100% - 300px);
  text-align: left;
  /* width: 98%; */
  overflow: auto;
  /* padding-right: 7px; */
  padding-top: 10px;
  background-color: #fff;
  margin-top: 0px;
  margin-left: 0px;
  border: 1px solid transparent;
  /* border-radius: 6px;
  border-top-left-radius: 0px;
  border-top-right-radius: 0px; */
  /* border-right: 1px solid lightgray; */
  /* border-bottom: 1px solid lightgray; */
}

.tree-node-browse {
  display: flex;
  flex-direction: column;
  font-family: Arial, Helvetica, sans-serif;
  height: calc(300px);
  text-align: left;
  overflow: auto;
  padding-top: 10px;
  background-color: #fff;
  margin-top: 0px;
  margin-left: 0px;
  border: 1px solid transparent;
  /* border-radius: 6px; */
  border-top-left-radius: 0px;
  border-top-right-radius: 0px;
  /* border-right: 1px solid lightgray; */
  border-top: 1px solid lightgray;

  cursor: ns-resize;
  /* Thay đổi con trỏ khi di chuột vào phía trên */
  user-select: none;
  /* Ngăn chặn việc chọn văn bản khi kéo */
}

.tree-node-directory ul {
  padding-left: 5px;
}

.tree-node-browse ul {
  padding-left: 5px;
}

.directory-option {
  /* font-family: Arial, Helvetica, sans-serif; */
  font-family: "Roboto", sans-serif;
  width: 100%;
  height: 160px;
  border: 1px solid transparent;
  text-align: left;
  padding-top: 10px;
  padding-bottom: 10px;
  /* margin-top: 5px; */
  /* margin-bottom: 5px; */
  background-color: none;
  font-size: 14px;
}
.layout-left-flex {
  height: 100%;
  width: 99%;
  border-bottom: 1px solid lightgray;
}
.layout-right-flex {
  width: 1%;
  border-right: 1px solid lightgray;
  border-bottom: 1px solid lightgray;
}

.browse-directory {
  color: #000;
  /* font-weight: bold; */
  padding-left: 20px;
  border: none;
  height: 45px;
  border-radius: 6px;
  margin-left: 5px;
  margin-right: 5px;
  cursor: pointer;
}

.favorites-directory {
  color: #000;
  /* font-weight: bold; */
  padding-left: 20px;
  border: none;
  height: 45px;
  border-radius: 6px;
  margin-left: 5px;
  margin-right: 5px;
  cursor: pointer;
}

.home-directory {
  color: #000;
  /* font-weight: bold; */
  padding-left: 20px;
  border: none;
  height: 45px;
  border-radius: 6px;
  margin-left: 5px;
  margin-right: 5px;
  cursor: pointer;
}

.browse-directory.active {
  /* color: #01579B; */
  color: #000;
  /* background-color: #fff; */
  font-weight: bold;
  border-color: #000;
  box-shadow: 0 0 10px #000;
}

.favorites-directory.active {
  /* color: #01579B; */
  color: #000;
  /* background-color: transparent; */
  font-weight: bold;
  border-color: #000;
  box-shadow: 0 0 10px #000;
}

.home-directory.active {
  /* color: #01579B; */
  color: #000;
  /* background-color: #fff; */
  font-weight: bold;
  border-color: #000;
  box-shadow: 0 0 10px #000;
}

.button-browse-directory {
  display: flex;
  border: none;
  border-radius: 4px;
  font-family: "Roboto", sans-serif;
  font-size: 14px;
  cursor: pointer;
  background-color: transparent;
  text-align: bottom;
  align-items: center;
  justify-content: center;
  padding: 10px;
  margin-right: 10px;
  text-decoration: none;
}

.icon-browse-directory {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/images/browse.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.icon-browse-directory.active {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/images/browse-active.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.icon-favorites-directory {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/images/favorites.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.icon-favorites-directory.active {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/images/favorites-active.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.icon-home-directory {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/images/home.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.icon-home-directory.active {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/images/home-active.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.component-select {
  width: 100%;
  display: flex;
  border: 1px solid transparent;
  justify-content: space-between;
  height: 50px;
}

.tab-content {
  border: none;
  height: calc(100% - 95px);
}

.item-select {
  border: none;
  text-align: center;
  vertical-align: middle;
  justify-content: center;
}

.item-select p {
  border: 1px solid none;
  display: flex;
  color: #b5b5b5;
  font-style: italic;
  align-items: center;
  font-size: 18px;
  padding-top: 10px;
  font-weight: bold;
}

.menu-select {
  display: flex;
  border: 1px solid transparent;
  font-family: "Roboto", sans-serif;
  font-size: 14px;
  padding-top: 5px;
  padding-right: 15px;
}

.setting-language {
  display: flex;
  border: 1px solid white;
  margin-left: 10px;
  justify-content: center;
  height: 40px;
  border-radius: 4px;
}

.setting-language:hover {
  border: 1px solid #64b5f6;
  background-color: #e3f2fd;
  transition: all 0.3s ease;
}

.button-setting-language {
  display: flex;
  border: none;
  cursor: pointer;
  background-color: transparent;
  text-align: bottom;
  align-items: center;
  justify-content: center;
  padding: 10px;
  margin-right: 10px;
  text-decoration: none;
}

.icon-setting-language {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/images/EnglishLanguage.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.icon-setting-language-vietNames {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/images/VietNamsLanguage.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.icon-translate {
  display: inline-block;
  margin-left: 5px;
  width: 24px;
  height: 24px;
  background-image: url(../assets/images/translate.png);
  background-size: cover;
  background-position: center;
  border: none;
}

.setting-user {
  display: flex;
  border: none;
  margin-left: 10px;
  justify-content: center;
}

.button-setting-user {
  display: flex;
  border: 1px solid white;
  height: 40px;
  border-radius: 4px;
  cursor: pointer;
  background-color: transparent;
  text-align: bottom;
  align-items: center;
  justify-content: center;
  padding: 10px;
  margin-right: 10px;
  text-decoration: none;
}

.button-setting-user:hover {
  border: 1px solid #64b5f6;
  background-color: #e3f2fd;
  transition: all 0.3s ease;
}

.icon-setting-user {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/images/my-profile-light.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.tree-node-file {
  float: right;
  width: 80%;
  height: 100%;
  border: 2px solid white;
  text-align: left;
  padding-left: 20px;
  overflow: auto;
  padding-right: 10px;
}

.directorySelectedClass {
  display: inline-block;
  width: 32px;
  height: 32px;
  background-image: url(../assets/folder_1.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: none;
}

.menubar {
  width: 100%;
  position: relative;
  display: flex;
  border: 1px solid none;
  margin-top: 0px;
  background-color: #000;
  align-items: right;
  color: #fff;
  font-family: "Roboto", sans-serif;
  border: none;
  height: 50px;
  justify-content: space-between;
  font-size: 14px;
}

.menu_logo {
  display: flex;
  padding-top: 5px;
  border: 1px solid transparent;
}

.logo-home {
  border: none;
  padding-bottom: 10px;
  margin-left: 10px;
}

.button-logo-home {
  display: flex;
  border: none;
  border-radius: 4px;
  font-family: Arial, Helvetica, sans-serif;
  font-size: 16px;
  cursor: pointer;
  background-color: transparent;
  text-align: bottom;
  align-items: center;
  justify-content: center;
  padding-left: 10px;
  margin-right: 10px;
  text-decoration: none;
}

.icon-logo-home {
  display: inline-block;
  width: 243px;
  height: 50px;
  background-image: url(../assets/images/logo.png);
  width: 161px;
  height: 28px;
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: 1px solid transparent;
  margin-top: 8px;
}

.menu_account {
  display: flex;
  border: 1px solid transparent;
  float: right;
  margin-right: 20px;
  font-family: Arial, Helvetica, sans-serif;
  justify-content: center;
}

.action-version {
  display: flex;
  border: none;
  justify-content: center;
  margin-left: 40px;
}

.action-help {
  display: flex;
  border: none;
  justify-content: center;
  margin-left: 10px;
}

.action-hotline {
  display: flex;
  border: none;
  justify-content: center;
  margin-left: 10px;
}

.vertial_line {
  display: flex;
  border: none;
  justify-content: center;
  margin-left: 10px;
}

.icon_account {
  display: inline-block;
  width: 27px;
  height: 27px;
  background-image: url(../assets/user.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  margin-bottom: 5px;
  border: none;
  display: inline-block;
  vertical-align: middle;
  border: none;
}

/* .open-privilege:hover {
    text-decoration: underline;
    transition: all 0.3s ease;
} */

.action-logout {
  margin-left: 10px;
  transition: all 0.3s ease;
}

.action-logout:hover {
  margin-left: 10px;
  text-decoration: underline;
  transition: all 0.3s ease;
}

.option {
  width: 100%;
  display: flexbox;
  border: 1px solid lightgray;
  margin-top: 0px;
  /* background: linear-gradient(to bottom, #B3E5FC, #90CAF9); */
  background-color: #fff;
  padding-left: 20px;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow: hidden;
  align-items: right;
  height: 52px;
  white-space: nowrap;
}

.footer-class {
  font-family: Arial, Helvetica, sans-serif;
  background-color: #395cae;
  color: #fff;
  text-align: left;
  border: 1px solid none;
  margin-top: 10px;
  padding: 10px;
  font-size: 20px;
  padding: 15px 30px;
  max-height: 30px;
  padding-bottom: 10px;
}

.table_info {
  display: flex;
  position: relative;
  border: 2px solid #f2f2f2;
  height: 45px;
  /* background: linear-gradient(to bottom, #f2f2f2, #FFF); */
  background-color: #f2f2f2;
  justify-content: center;
  align-items: center;
  vertical-align: middle;
  text-align: center;
}

.table_info_data {
  position: absolute;
  font-family: "Roboto", sans-serif;
  font-size: 14px;
  border: none;
  text-align: right;
  width: 100%;
  padding-right: 10px;
}

.hidden-input {
  display: none;
}

.title-change_password:hover {
  text-decoration: underline;
}

.icon_loading {
  width: 24px;
  height: 24px;
  border: 1px solid none;
  background: transparent;
  color: #333;
  background-image: url("../assets/loading.gif");
  background-size: 24px;
  font-size: 24px;
  background-repeat: no-repeat;
  background-color: rgba(0, 0, 0, 0);
  margin-right: 10px;
}
</style>
