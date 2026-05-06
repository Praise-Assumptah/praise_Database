import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.*;

public class HospitalERDSystem extends JFrame {
    // Database storage for our 5 project entities[cite: 2]
    private Map<String, Map<String, String[]>> db = new LinkedHashMap<>();
    private Map<String, DefaultListModel<String>> pkRegistries = new HashMap<>();

    public HospitalERDSystem() {
        setTitle("Hospital Equipment Management System - Professional ERD Suite");
        setSize(1300, 900);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        JTabbedPane tabbedPane = new JTabbedPane();

        // --- 1. DEPARTMENTS ---[cite: 2]
        setupTable(tabbedPane, "Departments", 
            new String[]{"Dept_id {PK}", "Dept_name", "Floor_location", "Head_of_dept", "Contact_ext"},
            new String[][]{
                {"D-101", "Radiology", "Floor 1", "Dr. Sarah", "4401"},
                {"D-102", "ICU", "Floor 2", "Dr. James", "4402"},
                {"D-103", "Emergency", "Ground", "Dr. Linda", "4400"}
            });

        // --- 2. SUPPLIERS ---[cite: 2]
        setupTable(tabbedPane, "Suppliers", 
            new String[]{"Supplier_id {PK}", "Company_name", "Contact_person", "Phone", "Address"},
            new String[][]{
                {"S-50", "MedEquip Ltd", "Mark Chen", "0722100200", "Nairobi Industrial Area"},
                {"S-51", "HealthCore", "Alice Wang", "0733400500", "Upper Hill, Nairobi"}
            });

        // --- 3. EQUIPMENT ---
        setupTable(tabbedPane, "Equipment", 
            new String[]{"Equip_id {PK}", "Name", "Status", "Dept_id {FK}", "Supplier_id {FK}"},
            new String[][]{
                {"EQ-001", "MRI Scanner", "Functional", "D-101", "S-50"},
                {"EQ-002", "Ventilator", "In-Repair", "D-102", "S-51"},
                {"EQ-003", "X-Ray", "Functional", "D-101", "S-50"}
            });

        // --- 4. TECHNICIAN ---[cite: 2]
        setupTable(tabbedPane, "Technician", 
            new String[]{"Tech_id {PK}", "Tech_name", "Specialty", "Exp_Level", "Availability"},
            new String[][]{
                {"T-001", "Praise", "Biomedical Engineering", "Expert", "Active"},
                {"T-002", "Alex", "Electrical Systems", "Senior", "On-Call"}
            });

        // --- 5. MAINTENANCE LOG ---
        setupTable(tabbedPane, "Maintenance log", 
            new String[]{"Log_id {PK}", "Date", "Description", "Equip_id {FK}", "Tech_id {FK}"},
            new String[][]{
                {"LOG-99", "2026-05-01", "Annual Calibration", "EQ-001", "T-001"},
                {"LOG-100", "2026-05-04", "Circuit Replacement", "EQ-002", "T-001"}
            });

        add(tabbedPane);
    }

    private void setupTable(JTabbedPane tabs, String name, String[] cols, String[][] data) {
        db.put(name, new LinkedHashMap<>());
        DefaultListModel<String> pkModel = new DefaultListModel<>();
        pkRegistries.put(name, pkModel);

        for (String[] row : data) {
            db.get(name).put(row[0], row);
            pkModel.addElement(row[0]);
        }
        tabs.addTab(name, createEntityPanel(name, cols));
    }

    private JPanel createEntityPanel(String entity, String[] cols) {
        JPanel panel = new JPanel(new BorderLayout());
        JPanel left = new JPanel(new BorderLayout());
        
        // Input Form
        JPanel form = new JPanel(new GridLayout(0, 2, 8, 8));
        form.setBorder(BorderFactory.createTitledBorder("Manage " + entity));
        JTextField[] fields = new JTextField[cols.length];
        for (int i = 0; i < cols.length; i++) {
            form.add(new JLabel("<html><b>" + cols[i] + "</b></html>"));
            fields[i] = new JTextField();
            form.add(fields[i]);
        }

        // SQL Command Buttons
        JPanel btnPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 10, 10));
        JButton selBtn = new JButton("SELECT");
        JButton insBtn = new JButton("INSERT");
        JButton updBtn = new JButton("UPDATE");
        JButton delBtn = new JButton("DELETE");
        
        // Styling for better interactivity
        selBtn.setToolTipText("Find record by ANY attribute filled above");
        insBtn.setToolTipText("Save this as a NEW record");
        updBtn.setToolTipText("Overwrite existing record using P.K.");

        btnPanel.add(selBtn); btnPanel.add(insBtn); btnPanel.add(updBtn); btnPanel.add(delBtn);
        left.add(form, BorderLayout.NORTH);
        left.add(btnPanel, BorderLayout.CENTER);

        // Sidebar P.K. Access for User Ease
        JList<String> pkList = new JList<>(pkRegistries.get(entity));
        pkList.addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting()) fields[0].setText(pkList.getSelectedValue());
        });
        JScrollPane pkScroll = new JScrollPane(pkList);
        pkScroll.setPreferredSize(new Dimension(180, 0));
        pkScroll.setBorder(BorderFactory.createTitledBorder("Stored P.K.s"));

        // Bottom Table View
        DefaultTableModel model = new DefaultTableModel(cols, 0);
        JTable table = new JTable(model);
        refreshUI(entity, model);

        // --- COMMAND LOGIC ---[cite: 5, 6]
        selBtn.addActionListener(e -> {
            String[] match = findData(entity, fields);
            if (match != null) {
                for (int i = 0; i < fields.length; i++) fields[i].setText(match[i]);
                JOptionPane.showMessageDialog(this, "Record found and loaded!");
            } else {
                JOptionPane.showMessageDialog(this, "No record matches the input values.");
            }
        });

        insBtn.addActionListener(e -> {
            String pk = fields[0].getText().trim();
            if (pk.isEmpty()) { JOptionPane.showMessageDialog(this, "Enter P.K. to Insert."); return; }
            if (db.get(entity).containsKey(pk)) {
                JOptionPane.showMessageDialog(this, "P.K. exists. Use UPDATE instead or load data.");
            } else {
                performSave(entity, fields, model);
                JOptionPane.showMessageDialog(this, "Success: New Record Added.");
            }
        });

        updBtn.addActionListener(e -> {
            String pk = fields[0].getText().trim();
            if (db.get(entity).containsKey(pk)) {
                performSave(entity, fields, model);
                JOptionPane.showMessageDialog(this, "Success: Record Updated.");
            } else {
                JOptionPane.showMessageDialog(this, "P.K. not found in database.");
            }
        });

        delBtn.addActionListener(e -> {
            String pk = fields[0].getText().trim();
            if (db.get(entity).remove(pk) != null) {
                pkRegistries.get(entity).removeElement(pk);
                refreshUI(entity, model);
                for(JTextField f : fields) f.setText("");
            }
        });

        JSplitPane split = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, left, pkScroll);
        panel.add(split, BorderLayout.NORTH);
        panel.add(new JScrollPane(table), BorderLayout.CENTER);
        return panel;
    }

    private String[] findData(String entity, JTextField[] fields) {
        for (String[] row : db.get(entity).values()) {
            for (int i = 0; i < fields.length; i++) {
                String input = fields[i].getText().trim();
                if (!input.isEmpty() && row[i].equalsIgnoreCase(input)) return row;
            }
        }
        return null;
    }

    private void performSave(String entity, JTextField[] fields, DefaultTableModel model) {
        String pk = fields[0].getText().trim();
        String[] data = new String[fields.length];
        for (int i = 0; i < fields.length; i++) data[i] = fields[i].getText();
        if (!db.get(entity).containsKey(pk)) pkRegistries.get(entity).addElement(pk);
        db.get(entity).put(pk, data);
        refreshUI(entity, model);
    }

    private void refreshUI(String entity, DefaultTableModel model) {
        model.setRowCount(0);
        db.get(entity).values().forEach(model::addRow);
    }

    public static void main(String[] args) {
        try { UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); } catch(Exception ignored) {}
        SwingUtilities.invokeLater(() -> new HospitalERDSystem().setVisible(true));
    }
}
